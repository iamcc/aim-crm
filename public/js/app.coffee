app = angular.module 'app', ['ngRoute', 'app.controllers', 'app.filters', 'app.services']

app.config [
  '$routeProvider', '$httpProvider'
  ($routeProvider, $httpProvider)->
    $routeProvider
      .when('/', {templateUrl: '/partials/user.html', controller: 'userCtrl'})
      .when('/login', {templateUrl: '/partials/login.html', controller: 'loginCtrl'})
      .when('/setting/:tab?', {templateUrl: '/partials/setting.html', controller: 'settingCtrl'})
      .when('/finance', {templateUrl: '/partials/finance.html', controller: 'financeCtrl'})
      .otherwise redirectTo: '/'

    $httpProvider.responseInterceptors.push [
      '$q', '$location'
      ($q, $location)->
        (promise)->
          success = (resp)-> resp
          error = (resp)->
            switch resp.status
              when 400 then console.log resp.data
              when 401 then $location.path '/login'
              when 403 then console.log resp.data
              when 404 then $location.path '/'
              when 500 then console.log resp.data
            console.log resp
            $q.reject resp

          promise.then success, error
    ]
]

app.run [
  '$rootScope', '$http'
  ($rootScope, $http)->
    $http
      .get('/api/user/me')
      .success (data)->
        $rootScope.userinfo = data
]


angular.bootstrap document, ['app']