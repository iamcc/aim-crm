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
          getSupporters:
            method: 'GET'
            params: _id: 'supporters'
            isArray: true
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
    'Project'
    [
      '$resource'
      ($resource)->
        $resource '/api/project/:_id', {_id: '@_id'},
          search:
            method: 'GET'
            params: act: 'search'
          update:
            method: 'PUT'
    ]
  )
  .factory(
    'Area'
    [
      '$resource'
      ($resource)->
        $resource '/api/area/:_id', _id: '@_id',
          all:
            method: 'GET'
            params: _id: 'all'
            isArray: true
          allCompanies:
            method: 'GET'
            params: _id: 'allCompanies'
            isArray: true
    ]
  )
  .factory(
    'Sales'
    [
      '$resource'
      ($resource)->
        $resource '/api/sales/:_id', _id: '@_id'
    ]
  )
  .factory(
    'Industry'
    [
      '$resource'
      ($resource)->
        $resource '/api/industry/:_id', _id: '@_id'
    ]
  )
  .factory(
    'Agent'
    [
      '$resource'
      ($resource)->
        $resource '/api/agent/:_id', _id: '@_id'
    ]
  )
.factory(
    'ProjectType'
    [
      '$resource'
      ($resource)->
        $resource '/api/projectType/:_id', _id: '@_id'
    ]
  )
.factory(
    'Finance'
    [
      '$resource'
      ($resource)->
        $resource '/api/finance/:_id', _id: '@_id',
    ]
  )
.factory(
    'Client'
    [
      '$resource'
      ($resource)->
        $resource '/api/client/:_id', _id: '@_id',
    ]
  )
.factory(
    'View'
    [
      '$resource'
      ($resource)->
        $resource '/api/view/:_id', _id: '@_id',
    ]
  )
.factory(
    'Product'
    [
      '$resource'
      ($resource)->
        $resource '/api/product/:_id', _id: '@_id',
    ]
  )