angular = require 'angular'

angular.module 'ThemisComponents', [
  require 'angular-animate'
]

require './thBindMarkdown/'
require './thButton/'
require './thCheckbox/'
require './thCompile/'
require './thComponentExample/'
require './thContentHeader/'
require './thContextualMessage/'
require './thDisclosure/'
require './thDropdown/'
require './thInput/'
require './thLazy/'
require './thLoader/'
require './thModal/'
require './thPopover/'
require './thRadioset/'
require './thSelect/'
require './thSwitch/'
require './thTabset/'
require './thWithLabel/'

module.exports = 'ThemisComponents'
