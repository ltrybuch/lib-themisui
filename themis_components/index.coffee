require '../public/javascript/prism.js'
require '../polyfills/'

angular.module 'ThemisComponents', [
  require 'angular-animate'
  require 'angular-aria'
  require 'angular-datepicker'
  require 'angular-messages'
  require 'angular-sanitize'
  require 'ui-select'
]
require './services/'
require './thActionBar/'
require './thAlert/'
require './thAutocomplete/'
require './thBindMarkdown/'
require './thButton/'
require './thCheckbox/'
require './thCompile/'
require './thComponentExample/'
require './thContentHeader/'
require './thContextualMessage/'
require './thDisclosure/'
require './thDatePicker/'
require './thDropdown/'
require './thError/'
require './thFilter/'
require './thInput/'
require './thLazy/'
require './thLoader/'
require './thModal/'
require './thPlural/'
require './thPopover/'
require './thRadioGroup/'
require './thSelect/'
require './thSwitch/'
require './thTable/'
require './thTabset/'
require './thTextarea/'
require './thTruncate/'
require './thViewModel/'
require './thWithFocus/'
require './thWithLabel/'
require './thWithMessages/'

module.exports = 'ThemisComponents'
