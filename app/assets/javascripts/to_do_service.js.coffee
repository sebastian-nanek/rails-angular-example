@todoservice = angular.module('ToDoService', ['ngResource'])
@todoservice.config ["$httpProvider", ($httpProvider) ->
  # provide CSRF token
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = document.getElementsByName("csrf-token")[0].content
  # provide JSON
  $httpProvider.defaults.headers.common['Accept'] = "application/json"
]

@todoservice.factory('ToDo', ['$resource', ($resource) ->
  $resource(
    '/to_dos/:id',
    { id: '@id' },
    { update: { method: 'PATCH' } }
  )
])
