angular
  .module('app.services', ['ngResource'])
  .factory(
    'User'
    [
      '$resource'
      ($resource)->
        $resource '/api/user/:_id', {_id: '@_id'},
          login:
            url: '/login'
            method: 'POST'
          checkLogin:
            method: 'GET'
            params: _id: 'me'
          setRealname:
            method: 'PUT'
            params: act: 'setrealname'
          setRole:
            method: 'PUT'
            params: act: 'setrole'
          setPwd:
            method: 'PUT'
            params: act: 'setpwd'
          resetPwd:
            method: 'PUT'
            params: act: 'resetpwd'
    ]
  )
  .factory(
    'Area'
    [
      '$resource'
      ($resource)->
        $resource '/api/area/:id', _id: '@_id'
    ]
  )
  .factory(
    'Sales'
    [
      '$resource'
      ($resource)->
        $resource '/api/sales/:id', _id: '@_id'
    ]
  )