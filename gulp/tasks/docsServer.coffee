gulp = require 'gulp'
glob = require 'glob'
path = require 'path'
fs = require 'fs'

componentsRoot = path.join 'themis_components'
componentDirectories = glob.sync path.join componentsRoot, '!(theme)', '/'
availableComponentNames = ( path.basename(item) for item in componentDirectories )

gulp.task 'docs-server', ->
  express = require 'express'
  app = express()

  app.use express.static 'public'

  app.get '/', (request, response) ->
    response.sendFile path.join 'public', 'index.html'

  app.get '/components.json', (request, response) ->
    componentList = availableComponentNames
    response.send componentList

  app.get '/components/:component.json', (request, response) ->
    componentName = request.params.component

    if componentName? and componentName in availableComponentNames
      response.send
        name: componentName
        readme: readmeForComponent componentName
        examples: examplesForComponent componentName
    else
      response.status(404).send error: "No such component."

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
  readme = """
    # #{componentName} does not have a Readme

    You should really make one.
  """

  readmePath = path.join componentsRoot, componentName, 'readme.md'
  if fs.existsSync readmePath
    readme = fs.readFileSync readmePath, 'utf8'

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