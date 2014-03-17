@todoapp = angular.module('todoapp', ['ToDoService'])

@todoapp.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    when('/to_dos', {
      templateUrl: '../templates/to_dos/index.html',
      controller: 'ToDosCtrl'
    }).
    when('/to_dos/new', {
      templateUrl: '../templates/to_dos/new.html',
      controller: 'NewToDoCtrl'
    }).
    when('/to_dos/:id/edit', {
      templateUrl: '../templates/to_dos/edit.html',
      controller: 'EditToDoCtrl'
    }).
    when('/sign_in', {
     templateUrl: '../templates/sessions/new.html',
     controller: 'SignInCtrl'
    }).
    when('/sign_out', {
      controller: 'SignOutCtrl',
      redirectTo: 'HomeCtrl'
    }).
    otherwise({
      templateUrl: '/templates/home.html',
      controller: 'HomeCtrl'
    })
])

@todoapp.controller 'EditToDoCtrl', ['$scope', 'ToDo', '$location', ($scope, ToDo, $location) ->
  $scope.to_do = ToDo.get(id: 13)
  $scope.update = (to_do) ->
    ToDo.update({ id: to_do.id }, {to_do: to_do})
    $location.path( "/to_dos" );
]

@todoapp.controller 'NewToDoCtrl', ['$scope', 'ToDo', '$location', ($scope, ToDo, $location) ->
  $scope.to_do = new ToDo()
  $scope.create = (to_do) ->
    t = new ToDo(to_do)
    ToDo.save({to_do: to_do})
    $location.path( "/to_dos" );
]

@todoapp.controller 'ToDosCtrl', ['$scope', 'ToDo', '$location', ($scope, ToDo, $location) ->
  $scope.to_dos = ToDo.query()

  $scope.new = new ToDo()

  $scope.delete = ($index) ->
    if confirm("Do you want to delete this item?")
      $scope.to_dos[$index].$delete()
      $scope.to_dos.splice($index, 1)

  $scope.edit = ($index) ->
    $location.path( "/to_dos/" + $scope.to_dos[$index].id + "/edit" );

  $scope.complete = ($index) ->
    if confirm("Do you want to this item as completed?")
      to_do = $scope.to_dos[$index]
      to_do.completed = true
      ToDo.update({ id: to_do.id }, {to_do: to_do})
]

@todoapp.controller 'SignInCtrl', ['$scope', '$location', '$http', '$rootScope', ($scope, $location, $http, $rootScope) ->
  $scope.errors = ""
  $scope.sign_in = (session) ->
    console.log(session.email)
    console.log(session.password)
    payload =
      email: session.email
      password: session.password
    $http.post('./token_session.json', payload).success((data) ->
      $rootScope.auth_token = data["auth_token"]
      $rootScope.user_id    = data["user_id"]
      $http.defaults.headers.common['X-Auth-Token'] = data["auth_token"]
      $location.path( "/to_dos" );
      session.errors = ""
    ).error(() ->
      session.email = ""
      session.password = ""
      $scope.errors = "Invalid e-mail or password."
    )
]

@todoapp.controller 'SignOutCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
  $rootScope.auth_token = ""
  $rootScope.user_id = ""
  $http.defaults.headers.common['X-Auth-Token'] = ""
  $http.delete('./users/sign_out', payload)
  $location.path( "/" );
]

@todoapp.controller 'HomeCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
]
