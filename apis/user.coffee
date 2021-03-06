User = require '../models/userModel'
async = require 'async'

method =
  GET: (req, res, next) ->
    user = req.user
    if req.params._id is 'me' or user.role not in ['leader', 'admin']
      copyUser = JSON.parse JSON.stringify user
      delete copyUser.pwd
      return res.send copyUser
    if _id = req.params._id
      if _id is 'supporters'
        return User.find {role: 'supporter'}, '_id realname', (err, docs)->res.send docs
      User.findById _id, (err, doc) ->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        return res.send null if user.role is 'leader' and doc and doc.role isnt 'supporter'
        res.send doc
    else
      condition = (query = req.query).condition or {}
      condition.role = 'supporter' if user.role is 'leader'
      condition.uname = $not: /admin/i
      num = query.num or 10
      page = query.page or 1
      opts =
        skip: (page - 1) * num
        limit: num
        sort: 'id'
      async.auto {
        count: (cb) ->
          User.count condition, cb
        list: (cb) ->
          User.find condition, null, opts, cb
      } ,
      (err, rst) ->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        res.send {
          totalPage: Math.ceil rst.count / num
          list: rst.list
        }

  PUT: (req, res, next) ->
    _id = req.params._id
    act = (query = req.query).act
    user = req.user

    switch act
      when 'setpwd' #modify pwd
        User.findById user._id, (err, doc)->
#          if err
#            console.log err
#            return res.send 500
          return next(err) if err
          return res.send 404 if not doc
          doc.pwd = req.body.pwd
          doc.save (err2)->
#            if err2
#              console.log err2
#              return res.send 500
            return next(err2) if err2
            res.send 200
      when 'resetpwd' #reset pwd
        return res.send 400 if not _id
        return res.send 403 if user.role not in ['leader', 'admin']
        User.findById _id, (err, doc)->
#          if err
#            console.log err
#            return res.send 500
          return next(err) if err
          return res.send 404 if not doc
          return res.send 400 if user.role is 'leader' and doc.role isnt 'supporter'
          doc.pwd = '123456'
          doc.save (err2)->
#            if err2
#              console.log err2
#              return res.send 500
            return next(err2) if err2
            res.send 200
      when 'setrealname' #modify realname
        return res.send 400 if not _id or not (realname = req.body.realname)
        return res.send 403 if user.role not in ['leader', 'admin']
        User.findById _id, (err, u)->
#          if err
#            console.log err
#            return res.send 500
          return next(err) if err
          return res.send 404 if not u
          return res.send 400 if user.role is 'leader' and u.role isnt 'supporter'
          u.realname = req.body.realname
          u.save (err2)->
#            if err2
#              console.log err2
#              return res.send 500
            return next(err2) if err2
            res.send 200
      when 'setrole' #modify role
        return res.send 403 if user.role isnt 'admin'
        User.findById _id, (err, doc)->
#          if err
#            console.log err
#            return res.send 500
          return next(err) if err
          return res.send 404 if not doc
          doc.role = req.body.role
          doc.save (err2)->
#            if err2
#              console.log err2
#              return res.send 500
            return next(err2) if err2
            res.send 200
      else res.send 400

  POST: (req, res, next) ->
    return res.send 403 if req.user.role not in ['leader', 'admin']
    user = new User req.body
    user.role = 'supporter' if req.user.role is 'leader'
    async.waterfall [
      (cb)->
        user.exists cb
      (existUser, cb)->
        return res.send 400, 'username existed' if existUser
        user.save cb
    ],
    (err, rst)->
#      if err
#        console.log err
#        return res.send 500
      return next(err) if err
      res.send 200

  # DELETE: (req, res, next) ->

module.exports = (req, res, next) ->
  try
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405