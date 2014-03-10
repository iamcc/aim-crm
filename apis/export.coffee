Project = require '../models/projectModel'

method =
  GET: (req, res, next) ->
    condition = JSON.parse (query = req.query).condition
    condition['supporter._id'] = req.user._id if req.user.role is 'supporter'
    if condition.sOrderDate
      condition.orderDate = condition.orderDate or {}
      condition.orderDate.$gte = condition.sOrderDate
      delete condition.sOrderDate
    if condition.eOrderDate
      condition.orderDate = condition.orderDate or {}
      condition.orderDate.$lte = condition.eOrderDate
      delete condition.eOrderDate

    opts =
      sort: '_id'

    Project.find condition, null, opts, (err, docs) ->
      return next err if err
      res.attachment 'export.xls'
      res.render 'export', data: docs

module.exports = (req, res, next) ->
  try
    method[req.method] req, res, next
  catch e
    console.log(e)
    res.send 405