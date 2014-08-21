app = angular.module 'app', ['ngRoute', 'app.controllers', 'app.filters', 'app.services', 'app.directives']

app.config [
  '$routeProvider', '$httpProvider'
  ($routeProvider, $httpProvider)->
    $routeProvider
      .when('/', {templateUrl: '/partials/user.html', controller: 'userCtrl'})
      .when('/area/:area', {templateUrl: '/partials/user.html', controller: 'userCtrl'})
      .when('/company/:company', {templateUrl: '/partials/user.html', controller: 'userCtrl'})
      .when('/industry/:industry', {templateUrl: '/partials/user.html', controller: 'userCtrl'})
      .when('/type/:type', {templateUrl: '/partials/user.html', controller: 'userCtrl'})
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
              when 404 then console.log resp.data
              when 500 then console.log resp.data
            console.log resp
            $q.reject resp

          promise.then success, error
    ]
]

app.run [
  '$rootScope', '$http', 'ProjectType', 'Industry', 'Agent', 'User', 'Area', 'View'
  ($rootScope, $http, ProjectType, Industry, Agent, User, Area, View)->
    $http
      .get('/api/user/me')
      .success (data)->
        $rootScope.userinfo = data

        if data.role in ['supporter', 'market', 'leader', 'admin']
          $rootScope.projectTypes = ProjectType.query({}, -> t.url = '/type/' + t._id for t in $rootScope.projectTypes)
          $rootScope.industries = Industry.query({}, -> i.url = '/industry/' + i._id for i in $rootScope.industries)
          $rootScope.agents = Agent.query({_id: 'all'})
          $rootScope.supporters = User.getSupporters() if $rootScope.userinfo.role isnt 'supporter'
          $rootScope.areas = Area.all({}, -> a.url = '/area/' + a._id for a in $rootScope.areas)
          $rootScope.companies = Area.allCompanies({}, -> c.url = '/company/' + c._id for c in $rootScope.companies)
          $rootScope.views = []
          View.query {}, (views) ->
            for c in views
              for v in c.names
                $rootScope.views.push {catalog: c.catalog, name: v}
]


angular.bootstrap document, ['app']