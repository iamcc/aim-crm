User = require '../models/userModel'
async = require 'async'

method =
  GET: (req, res, next)->
    user = req.session.user
    return res.send 403 if user.role not in ['leader', 'admin']
    switch user.role
      when 'leader'
        if _id = req.params._id
          condition = _id: _id, role: 'supporter'
          User.findOne condition, (err, doc)->
            if err
              console.log err
              return res.send 500
            res.send doc
        else
          condition = (query = req.query).condition
          num = query.num or 10
          page = query.page or 1
          opts =
            skip: (page-1)*num
            limit: num
          async.auto {
            count: (cb)->
              User.count condition, cb
            list: (cb)->
              User.find condition, null, opts, cb
          } ,
          (err, rst)->
            if err
              console.log err
              return res.send 500
            res.send {
              totalPage: Math.ceil rst.count/num
              list: rst.list
            }

      when 'admin'
      else res.send 403

  PUT: (req, res, next)->
  POST: (req, res, next)->
  DELETE: (req, res, next)->

module.exports = (req, res, next)->
  try
    method[req.method] req, res, next
  catch e
    res.send 405