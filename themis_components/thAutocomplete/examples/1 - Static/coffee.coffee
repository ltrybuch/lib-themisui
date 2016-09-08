angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ->
    @cities = null
    @cityOptions = [
      {id: 0, name: 'Toronto'}
      {id: 1, name: 'Montreal'}
      {id: 2, name: 'Calgary'}
      {id: 3, name: 'Ottawa'}
      {id: 4, name: 'Edmonton'}
      {id: 5, name: 'Mississauga'}
      {id: 6, name: 'Winnipeg'}
      {id: 7, name: 'Vancouver'}
      {id: 8, name: 'Brampton'}
      {id: 9, name: 'Hamilton'}
      {id: 10, name: 'Quebec City'}
      {id: 11, name: 'Surrey'}
      {id: 12, name: 'Laval'}
      {id: 13, name: 'Halifax'}
      {id: 14, name: 'London'}
      {id: 15, name: 'Markham'}
      {id: 16, name: 'Vaughan'}
      {id: 17, name: 'Gatineau'}
      {id: 18, name: 'Longueuil'}
      {id: 19, name: 'Burnaby'}
    ]

    @delegate =
      displayField: 'name'
      fetchData: ({searchString}, updateData) =>
        if searchString?.length > 0
          lowerCaseSearchString = searchString.toLowerCase()

          updateData(
            @cityOptions.filter (city) ->
              city.name.toLowerCase().indexOf(lowerCaseSearchString) isnt -1
          )
        else
          updateData []

    return
