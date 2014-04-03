View = require '../models/viewModel'
Project = require '../models/projectModel'
helper = require '../commons/helper'

method =
  GET: (req, res, next) ->
    if req.params._id is 'all' then return View.find {}, (err, docs)-> res.send docs

    helper.getPage View, req.query, (err, data) ->
      res.send data
  POST: (req, res, next) ->
    delete req.body._id
    if req.params._id
      View.findByIdAndUpdate req.params._id, req.body, (err, doc) ->
        return next err if err
        Project.update {'view._id': doc._id}, {'view.name': doc.name}, {multi: true}, (err, num) ->
          console.log err if err
        res.send 200
    else
      View.create req.body, (err) ->
        return next err if err
        res.send 200

module.exports = (req, res, next) ->
  try
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405