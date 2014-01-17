// Generated by CoffeeScript 1.6.3
(function() {
  angular.module('app.services', ['ngResource']).factory('User', [
    '$resource', function($resource) {
      return $resource('/api/user/:_id', {
        _id: '@_id'
      }, {
        login: {
          url: '/login',
          method: 'POST'
        },
        checkLogin: {
          method: 'GET',
          params: {
            _id: 'me'
          }
        },
        setRealname: {
          method: 'PUT',
          params: {
            act: 'setrealname'
          }
        },
        setRole: {
          method: 'PUT',
          params: {
            act: 'setrole'
          }
        },
        setPwd: {
          method: 'PUT',
          params: {
            act: 'setpwd'
          }
        },
        resetPwd: {
          method: 'PUT',
          params: {
            act: 'resetpwd'
          }
        }
      });
    }
  ]);

}).call(this);
