Sales = require '../models/salesModel'
async = require 'async'

method =
  GET: (req, res, next)->
    if (_id = req.params._id)
      console.log _id
    else
      if (query = req.query).s
        Sales.find name: new RegExp(req.query.s, 'i'), null, {limit: 10}, (err, docs)->
#          if err
#            console.log err
#            return res.send 500
          return next(err) if err
          res.send docs
      else if query.company
        Sales.find {'company._id': query.company}, null, {sort: 'name'}, (err, docs)->
#          if err
#            console.log err
#            return res.send 500
          return next(err) if err
          res.send docs

  # PUT: (req, res, next)->
  POST: (req, res, next)->
    _id = req.body._id
    delete req.body._id

    if _id
      Sales.findByIdAndUpdate _id, req.body, (err)->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        res.send 200
    else
      Sales.create req.body, (err)->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        res.send 200

  # DELETE: (req, res, next)->

module.exports = (req, res, next) ->
  try
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405