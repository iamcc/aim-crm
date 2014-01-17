Project = require '../models/projectModel'
_ = require 'underscore'
async = require 'async'

method =
  GET: (req, res, next) ->
    if _id = req.params._id
      Project.findById _id, (err, doc) ->
        if err
          console.log err
          return res.send 500
        res.send doc
    else
      condition = (query = req.query).condition
      num = query.num or 10
      page = query.page or 1
      opts =
        skip: (page - 1) * num
        limit: num

      async.auto {
        count: (cb) ->
          Project.count condition, cb
        list: (cb) ->
          Project.find condition, null, opts, cb
      } ,
      (err, rst) ->
        if err
          console.log err
          return res.send 500
        res.send {
          totalPage: Math.ceil rst.count / num
          list: rst.list
        }

  PUT: (req, res, next) ->
    return res.send 400 if not (_id = req.params._id)
    delete res.body._id if res.body._id
    Project.update {_id: _id} , res.body, (err, doc)->
      if err
        console.log err
        return res.send 500
      res.send 200
  POST: (req, res, next) ->
    doc = new Project req.body
    doc.save (err, doc) ->
      if err
        console.log err
        return res.send 500
      res.send 200
  DELETE: (req, res, next) ->
    res.send 400 if not (_id = req.params._id)
    Project.findByIdAndRemove _id, (err) ->
      if err
        console.log err
        return res.send 500
      res.send 200

module.exports = (req, res, next) ->
  try
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405