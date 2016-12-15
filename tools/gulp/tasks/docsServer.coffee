gulp = require 'gulp'
glob = require 'glob'
path = require 'path'
fs = require 'fs'
coffeescript = require 'coffee-script'

express = require 'express'
bodyParser = require 'body-parser'

componentsRoot = path.join 'src', 'lib'

metaFor = (componentPath) ->
  try
    JSON.parse fs.readFileSync(path.join(componentPath, 'meta.json'), 'utf8')
  catch
    {}

componentDirectories = ->
  directories = {}
  allDirectories = glob.sync path.join componentsRoot, '!(theme)', '/'
  for directory in allDirectories
    directories[directory] = metaFor directory

  return directories

availableComponentNames = ->
  for item, meta of componentDirectories() when meta.private isnt true
    path.basename(item)

app = express()


app.use bodyParser.json() # support json encoded bodies
app.use bodyParser.urlencoded extended: true # support encoded bodies

# Restart app when there are open web sockets (triggers browser reload)
gulp.task 'docs-restart', ->
  if app.wsClients().length > 0
    app.restart()

gulp.task 'docs-server', ->
  expressWs = require 'express-ws'

  # WebSocket
  webSocketApp = expressWs(app)
  app.ws '/channel', -> # no-op

  gulp.watch ['src/lib/**/*',
              'src/docs-app/**/*',
              'src/themes/**/*'], ['docs-restart']

  app.get '/readme.md', (request, response) ->
    response.sendFile path.resolve(path.join('README.md'))

  app.get '/version.json', (request, response) ->
    packageFile = fs.readFileSync 'package.json', 'utf8'
    version = JSON.parse(packageFile).version
    response.send
      version: version

  app.get '/components.json', (request, response) ->
    componentList = availableComponentNames()
    response.send componentList

  app.get '/components/:component.json', (request, response) ->
    componentName = request.params.component

    if componentName? and componentName in availableComponentNames()
      {markdown, html} = readmeForComponent componentName

      response.send
        name: componentName
        readme: markdown
        readmeHTML: html
        examples: examplesForComponent componentName
    else
      response.status(404).send error: "No such component."

  app.post '/echo', (request, response) ->
    response.send JSON.stringify request.body

  app.get '/components/:component/examples/:example.js', (request, response) ->
    componentName = request.params.component
    exampleName = request.params.example

    exampleCoffeeFile = path.join componentsRoot, componentName, 'examples', exampleName, 'coffee.coffee'
    exampleCoffee = fs.readFileSync exampleCoffeeFile, 'utf8'
    response.set('Content-Type', 'application/javascript').send coffeescript.compile exampleCoffee

  serveIndex = (request, response) ->
    response.sendFile path.resolve(path.join('src', 'docs-app', 'index.html'))

  app.get '', serveIndex
  app.get '/:componentName', serveIndex

  app.use "/public", express.static 'src/docs-app'
  app.use "/build", express.static 'dist'
  app.use "/exampleTemplates", express.static 'src/docs-app/exampleTemplates'

  # Start server on port 3042
  server = null
  startServer = ->
    port = process.env.PORT ? 3042

    server = app.listen port, ->
      host = server.address().address
      port = server.address().port

      console.log """
        ####################

        Running ThemisUI Docs on port #{port}.
          http://%s:%s

        ####################
      """, host, port

  startServer()

  app.wsClients = -> webSocketApp.getWss('/channel').clients

  app.restart = ->
    @wsClients().forEach (client) -> client.close()
    server.close()
    server = startServer()

readmeForComponent = (componentName) ->
  readme =
    markdown: """
      # #{componentName} does not have a Readme

      You should really make one.
    """
    html: ""

  readmePath = path.join componentsRoot, componentName, 'readme.md'
  if fs.existsSync readmePath
    readme.markdown = fs.readFileSync readmePath, 'utf8'

  readmePath = path.join componentsRoot, componentName, 'readme.html'
  if fs.existsSync readmePath
    readme.html = fs.readFileSync readmePath, 'utf8'

  return readme

examplesForComponent = (componentName) ->
  examplesDirectory = path.join componentsRoot, componentName, 'examples'

  if fs.existsSync(examplesDirectory) and fs.statSync(examplesDirectory).isDirectory()
    examples = []
    exampleDirectorys = glob.sync path.join examplesDirectory, '*', '/'

    for exampleDirectory in exampleDirectorys
      example =
        name: path.basename exampleDirectory

      pieces =
        html: 'html.html'
        coffee: 'coffee.coffee'

      for piece, filename of pieces
        file = path.join exampleDirectory, filename
        example[piece] = fs.readFileSync file, 'utf8' if fs.existsSync file

      examples.push example

    return examples
  else
    return []
