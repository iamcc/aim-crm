Client = require '../models/clientModel'
helper = require '../commons/helper'

method =
  GET: (req, res, next) ->
    if req.params._id
      res.send 404
    else
      if req.query.s
        Client.find {'name': new RegExp(req.query.s, 'i')}, null, {limit: 10}, (err, docs) ->
          res.send docs
      else
        helper.getPage Client, req.query, (err, data) ->
          res.send data
  POST: (req, res, next) ->
    delete req.body._id
    if req.params._id
      Client.findByIdAndUpdate req.params._id, req.body, (err, doc) ->
        return next err if err
        res.send 200
    else
      Client.create req.body, (err) ->
        return next err if err
        res.send 200

module.exports = (req, res, next) ->
  try
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405