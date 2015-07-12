gulp = require 'gulp'
glob = require 'glob'
path = require 'path'
fs = require 'fs'
coffeescript = require 'coffee-script'

componentsRoot = path.join 'themis_components'
componentDirectories = -> glob.sync path.join componentsRoot, '!(theme)', '/'
availableComponentNames = -> ( path.basename(item) for item in componentDirectories() )

gulp.task 'docs-server', ->
  express = require 'express'
  app = express()

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

  app.get '/components/:component/examples/:example.js', (request, response) ->
    componentName = request.params.component
    exampleName = request.params.example

    exampleCoffeeFile = path.join componentsRoot, componentName, 'examples', exampleName, 'coffee.coffee'
    exampleCoffee = fs.readFileSync exampleCoffeeFile, 'utf8'
    response.set('Content-Type', 'application/javascript').send coffeescript.compile exampleCoffee

  # Read index.html into memory and replace __BASE_PATH__ with correct value, then send as response.
  serveIndex = (request, response) ->
    indexPath = __dirname + '/../../public/index.html'
    fs.readFile path.normalize(indexPath), {encoding: "UTF-8"}, (err, data) ->
      throw err if err?
      response.send(data.replace(/__BASE_PATH__/g, ""))

  app.get '', serveIndex
  app.get '/:componentName', serveIndex

  app.use express.static 'public'

  server = app.listen 3042, ->
    host = server.address().address
    port = server.address().port

    console.log """
      ####################

      Running ThemisUI Docs on port #{port}.
        http://%s:%s

      ####################
    """, host, port

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
