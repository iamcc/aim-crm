angular
  .module('app.services', ['ngResource'])
  .factory(
    'User',
    [
      '$resource'
      ($resource)->
        $resource '/api/user/:_id', null,
          login:
            url: '/login'
            method: 'POST'
          setPwd:
            method: 'PUT'
            params: act: 'setpwd'
          resetPwd:
            method: 'PUT'
            params: act: 'resetpwd'
    ]
  )