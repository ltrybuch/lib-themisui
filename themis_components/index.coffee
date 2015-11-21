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
require './thModal/'
require './thPopover/'
require './thSelect/'
require './thSwitch/'
require './thTable/'
require './thTabset/'

module.exports = 'ThemisComponents'
