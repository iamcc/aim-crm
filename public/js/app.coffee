app = angular.module 'app', ['ngRoute', 'ngResource', 'app.controllers']

app.config [
  '$routeProvider', '$httpProvider'
  ($routeProvider, $httpProvider)->
    $routeProvider
      .when('/', {templateUrl: '/partials/user.html', controller: 'userCtrl'})
      .when('/finance', {templateUrl: '/partials/finance.html', controller: 'financeCtrl'})
      .otherwise redirectTo: '/'

    $httpProvider.responseInterceptors.push [
      '$q'
      ($q)->
        (promise)->
          success = (resp)-> resp
          error = (resp)->
            console.log resp
            $q.reject resp

          promise.then success, error
    ]
]

angular.bootstrap document, ['app']