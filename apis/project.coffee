Project = require '../models/projectModel'
_ = require 'underscore'

method =
  GET: (req, res, next)->
    if _id = req.params._id
      Project.findById _id, (err, doc)->
        if err
          console.log err
          return res.send 500
        res.send doc
    else
      {filter, opts} = req.query
      Project.find filter, null, opts, (err, docs)->
        if err
          console.log err
          return res.send 500
        res.send docs
  PUT: (req, res, next)->
    return res.send 400 if not (_id = req.params._id)
    delete res.body._id if res.body._id
    Project.update {_id: _id}, res.body, ->
    res.send 200
  POST: (req, res, next)->
    doc = new Project req.body
    doc.save (err, doc)->
      if err
        console.log err
        return res.send 500
      res.send 200
  DELETE: (req, res, next)->
    res.send 400 if not (_id = req.params._id)
    Project.findByIdAndRemove _id, (err)->
      if err
        console.log err
        return res.send 500
      res.send 200

module.exports = (req, res, next)->
  try
    method[req.method] req, res, next
  catch e
    res.send 405