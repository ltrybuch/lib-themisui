angular = require 'angular'

angular.module 'ThemisComponents', [
  require 'angular-animate'
]

require './thBindMarkdown'
require './thComponentExample'
require './thContextualMessage'
require './thPopover'
require './thSwitch'

module.exports = 'ThemisComponents'