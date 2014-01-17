Sales = require '../models/salesModel'
async = require 'async'

method =
  GET: (req, res, next)->
    if (_id = req.params._id)
      console.log _id
    else

  PUT: (req, res, next)->
  POST: (req, res, next)->
  # DELETE: (req, res, next)->

module.exports = (req, res, next) ->
  try
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405