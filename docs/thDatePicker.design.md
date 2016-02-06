thDatePicker Design docs

# DESIGN DOCS

## Where in Clio Date Pickers appear:
(as modals)
 - add/edit task
 - add/edit calendar entry
- add time entry for task
- add/edit matter
(as pages)
- bill export new http://0.0.0.0:3000/bill_export/new
- bank transaction export http://0.0.0.0:3000/bank_transaction_export/new

## Candidate Libraries

### Angular Moment Picker
- uses moment
- nice internationalization support
- fairly new repo with recent activity
http://indrimuska.github.io/angular-moment-picker/

### Angular Datepicker
- supports many functional improvements over existing datepicker (timezone,time,range)
- doesn’t rely on bootstrap
- healthy project/contributors
- time input seems cumbersome
- unsure of styling options
https://github.com/g00fy-/angular-datepicker

### nzDatepicker 
** questionable use of bower
- forked from an out of date implementation that was superceded by Angular Might Datepicker
https://github.com/nozzle/nzDatepicker

### Angular-datepicker
** tried this one, has weird handling of dates and formats when inputting text
- has extra year selector we may not want/need (it's okay)
- project repo is active
https://github.com/720kb/angular-datepicker#angular-datepicker

### Angular Mighty Datepicker
- moderately healthy git project (smallish)
- light
- relies on outdated library
https://github.com/monterail/angular-mighty-datepicker

## Discarded Libraries (Bootstrap reliant)
### Angular Bootstrap Calendar  - NO
- the whole HOG / kitchen sink - i.e. too much
- bootstrap, others
http://mattlewis92.github.io/angular-bootstrap-calendar/

### Angular Bootstrap Datepicker
- kitchen sink, lot of customization we don’t need
- looks like what we need out of the box, but
- repo has recent releases and decent # contributors
https://angular-ui.github.io/bootstrap/#/datepicker

### AngularStrap - the whole library, includes a datepicker
http://mgcrea.github.io/angular-strap/#
http://mgcrea.github.io/angular-strap/#/datepickers

### angular-bootstrap-datepicker
** maybe this one?
- solo project, port
- light
https://github.com/cletourneau/angular-bootstrap-datepicker

### Sources
- https://ngmodules.com/categories/datepicker
- http://angularjs4u.com/datepicker/top-5-datepicker-angularjs-modules/