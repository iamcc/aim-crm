// Generated by CoffeeScript 1.7.1
(function() {
  var app;

  app = angular.module('app', ['ngRoute', 'app.controllers', 'app.filters', 'app.services', 'app.directives']);

  app.config([
    '$routeProvider', '$httpProvider', function($routeProvider, $httpProvider) {
      $routeProvider.when('/', {
        templateUrl: '/partials/user.html',
        controller: 'userCtrl'
      }).when('/area/:area', {
        templateUrl: '/partials/user.html',
        controller: 'userCtrl'
      }).when('/company/:company', {
        templateUrl: '/partials/user.html',
        controller: 'userCtrl'
      }).when('/industry/:industry', {
        templateUrl: '/partials/user.html',
        controller: 'userCtrl'
      }).when('/type/:type', {
        templateUrl: '/partials/user.html',
        controller: 'userCtrl'
      }).when('/login', {
        templateUrl: '/partials/login.html',
        controller: 'loginCtrl'
      }).when('/setting/:tab?', {
        templateUrl: '/partials/setting.html',
        controller: 'settingCtrl'
      }).when('/finance', {
        templateUrl: '/partials/finance.html',
        controller: 'financeCtrl'
      }).otherwise({
        redirectTo: '/'
      });
      return $httpProvider.responseInterceptors.push([
        '$q', '$location', function($q, $location) {
          return function(promise) {
            var error, success;
            success = function(resp) {
              return resp;
            };
            error = function(resp) {
              switch (resp.status) {
                case 400:
                  console.log(resp.data);
                  break;
                case 401:
                  $location.path('/login');
                  break;
                case 403:
                  console.log(resp.data);
                  break;
                case 404:
                  console.log(resp.data);
                  break;
                case 500:
                  console.log(resp.data);
              }
              console.log(resp);
              return $q.reject(resp);
            };
            return promise.then(success, error);
          };
        }
      ]);
    }
  ]);

  app.run([
    '$rootScope', '$http', 'ProjectType', 'Industry', 'Agent', 'User', 'Area', 'View', function($rootScope, $http, ProjectType, Industry, Agent, User, Area, View) {
      return $http.get('/api/user/me').success(function(data) {
        var _ref;
        $rootScope.userinfo = data;
        if ((_ref = data.role) === 'supporter' || _ref === 'leader' || _ref === 'admin') {
          $rootScope.projectTypes = ProjectType.query({}, function() {
            var t, _i, _len, _ref1, _results;
            _ref1 = $rootScope.projectTypes;
            _results = [];
            for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
              t = _ref1[_i];
              _results.push(t.url = '/type/' + t._id);
            }
            return _results;
          });
          $rootScope.industries = Industry.query({}, function() {
            var i, _i, _len, _ref1, _results;
            _ref1 = $rootScope.industries;
            _results = [];
            for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
              i = _ref1[_i];
              _results.push(i.url = '/industry/' + i._id);
            }
            return _results;
          });
          $rootScope.agents = Agent.query({
            _id: 'all'
          });
          if ($rootScope.userinfo.role !== 'supporter') {
            $rootScope.supporters = User.getSupporters();
          }
          $rootScope.areas = Area.all({}, function() {
            var a, _i, _len, _ref1, _results;
            _ref1 = $rootScope.areas;
            _results = [];
            for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
              a = _ref1[_i];
              _results.push(a.url = '/area/' + a._id);
            }
            return _results;
          });
          $rootScope.companies = Area.allCompanies({}, function() {
            var c, _i, _len, _ref1, _results;
            _ref1 = $rootScope.companies;
            _results = [];
            for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
              c = _ref1[_i];
              _results.push(c.url = '/company/' + c._id);
            }
            return _results;
          });
          return $rootScope.views = View.query({
            _id: 'all'
          });
        }
      });
    }
  ]);

  angular.bootstrap(document, ['app']);

}).call(this);

//# sourceMappingURL=app.map
