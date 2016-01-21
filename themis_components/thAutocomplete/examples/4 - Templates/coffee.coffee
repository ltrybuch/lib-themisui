angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ($http) ->

    @value = null

    @fetchData = ({term}, updateData) ->
      $http
        method: 'GET'
        url: 'https://api.github.com/search/repositories'
        params:
          q: term
      .then (response) ->
        updateData response.data.items.map (item) ->
          angular.extend(item, {
            # Required parameters
            text: item.name
            id: item.id
          })
      return

    @resultTemplate = (repo) ->
      markup =
        " \
        <div class='select2-result-repository clearfix'> \
          <div class='select2-result-repository__avatar'> \
            <img src='" + repo.owner.avatar_url + "' /> \
          </div> \
          <div class='select2-result-repository__meta'> \
            <div class='select2-result-repository__title'>" +
              repo.full_name + " \
            </div>"

      markup +=
        " \
            <div class='select2-result-repository__description'>" +
              repo.description + " \
            </div>" if repo.description

      markup +=
        " \
            <div class='select2-result-repository__statistics'> \
              <div class='select2-result-repository__forks'> \
                <i class='fa fa-flash'></i> " +
                repo.forks_count + " Forks \
              </div> \
              <div class='select2-result-repository__stargazers'> \
                <i class='fa fa-star'></i> " +
                repo.stargazers_count +
                " Stars \
              </div> \
              <div class='select2-result-repository__watchers'> \
                <i class='fa fa-eye'></i> " +
                repo.watchers_count + " Watchers \
              </div> \
            </div> \
          </div> \
        </div>"

      return markup

    @selectionTemplate = (repo) ->
      return repo.name

    return
