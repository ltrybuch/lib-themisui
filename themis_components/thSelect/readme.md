# DESIGN DOCS

## STANDARD EXAMPLE
---
```
<select name="select">
  <option value="value1">Value 1</option>
  <option value="value2" selected>Value 2</option>
  <option value="value3">Value 3</option>
</select>
```
![Standard](http://zippy.gfycat.com/WeeklyDizzyHind.gif "Standard Select")

## AN ANGULAR EXAMPLE
---

```
angular.module('ngrepeatSelect', [])
 .controller('ExampleController', ['$scope', function($scope) {
   $scope.data = {
    singleSelect: null,
    availableOptions: [
      {id: '1', name: 'Option A'},
      {id: '2', name: 'Option B'},
      {id: '3', name: 'Option C'}
    ],
   };
}]);
```

```
<div ng-controller="ExampleController">
  <form name="myForm">
    <label for="repeatSelect"> Repeat select: </label>
    <select name="repeatSelect" ng-model="data.repeatSelect">
      <option ng-repeat="option in data.availableOptions" value="{{option.id}}">{{option.name}}</option>
    </select>
  </form>
  <hr>
  <tt>repeatSelect = {{data.repeatSelect}}</tt><br/>
</div>
```
![Angular](http://zippy.gfycat.com/CornyNegativeCorydorascatfish.gif "Angular Select")


## THOUGHTS
---
- `<optgroup>` should be as easy as just passings separated named arrays
  ```
  groceries = [
    dairy = [
      { name: "Eggs", value: "eggs" }
      { name: "Milk", value: "milk" }
    ]
    vegetable = [
      { name: "Lettuce", value: "lettuce" }
      { name: "Carrots", value: "carrots" }
    ]
    fruit = [
      { name: "Apple", value: "apple" }
      { name: "Cherries", value: "cherries" }
    ]
  ]
  ```
- Creating a wrapper angular component for Select2 would solve a lot of our problems and could get us moving in the right direction quickly.
- We could roll out the different options as they are ready but allowing them to be passed in as options.
- If this library is meant to be open source we are not adding dependencies in jQuery and Select2. I'm not sure if that is important or not.
- Autocomplete can be replace with this same manner by using Select2 `ajax` option to list results.
- Use promise to load data into our select?
  ```
  populate: ->
    deferred = $q.defer()
    arr = [],
    $.ajax(
      url: 'https://api.clio.com/contacts'
    ).done (data) ->
      contact in data
        arr.push contact.name
            deferred.resolve(arr);
    return deferred;
  ```


### SOME JS/JQ SELECTS AVAILABLE
- Select
  - http://github.hubspot.com/select/docs/welcome/
  - A little too simple and nothing that we could build ourselves.
  - untested
- Chosen
  - https://github.com/harvesthq/chosen
  - Not too much activity on the repo lately.
  - Heavy for what it does
  - already in use in Clio
- Select2
  - https://github.com/select2/select2
  - active. new version 4.0 around the corner with some nice features!
  - lightweight. 72kb full minified
- ui-select
  - https://github.com/angular-ui/ui-select
  - Angular wrapper for Select2
  - **This could be a solution for us**. It can be rewritten with just what we need/want and slowly added to.
- selectBoxit
  - http://gregfranko.com/jquery.selectBoxIt.js/index.html
  - fairly clean and customizable
  - requires jQueryUI Widget Factory
  - easy to read docs




### SIMPLE EXAMPLE
---
mockup example:
````
<th-select options="options" placeholder="pick one..." icon="car" label="Cars" ng-model='selectedCar'></th-select>
```

example taken from Clio:

![Select replacement](http://zippy.gfycat.com/FrayedBrightIndianglassfish.gif "Clio Select")


### WITH SEARCH FIELD
---
mockup example:
```
<th-select options="options" placeholder="pick one..." icon="gavel" label="Practice Area" ng-model='selectedPractice' search="true" reset="true"></th-select>
```

example taken from Clio:

![Select with search](https://s3.amazonaws.com/uploads.hipchat.com/21744/2190491/iPXDMuffvsMP5zn/select_with_search.gif "Clio select")
---

### CHECKBOXES
---
mockup example:
```
<th-select options="options" checkbox="true" placeholder="check at least one..." label="Allowed Roles" ng-model='selectedRoles'></th-select>
```

![Checkbox dropdown](http://zippy.gfycat.com/EveryBigheartedDunlin.gif "Checkbox dropdown")

### TAGS / MULTISELECT
---
mockup example:
```
<th-select options="options" tags="true" placeholder="Atendees..." ng-model='selectedUsers' max="3"></th-select>
```
example taken from Clio:

![Tags](http://zippy.gfycat.com/CourageousLeadingDuckling.gif "Tags")




