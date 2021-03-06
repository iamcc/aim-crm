Area = require '../models/areaModel'
async = require 'async'

method =
  GET: (req, res, next)->
    if (_id = req.params._id)
      if _id is 'all' then return Area.find {parent: req.query.parent}, null, {sort: 'name'}, (err, docs)->res.send docs
      else if _id is 'allCompanies' then return Area.find {parent: $ne: null}, null, {sort: 'name'}, (err, docs)->res.send docs
      Area.findById _id, (err, doc)->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        res.send doc
    else
      condition = parent: (query = req.query).parent
      num = query.num or 10
      page = query.page or 1
      opts =
        skip: (page - 1) * num
        limit: num
        sort: '-_id'

      async.auto {
        count: (cb) ->
          Area.count condition, cb
        list: (cb) ->
          Area.find condition, null, opts, cb
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
  # PUT: (req, res, next)->
  #   return res.send 400 if not (_id = req.params._id)
  #   delete req.body._id
  #   Area.findByIdAndUpdate _id, req.body, (err, doc)->
  #     if err
  #       console.log err
  #       return res.send 500
  #     res.send 200
  POST: (req, res, next)->
    return res.send 403 if req.user.role not in ['leader', 'admin']
    _id = req.body._id
    delete req.body._id

    if _id
      Area.findByIdAndUpdate _id, req.body, (err, doc)->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        res.send 200
    else
      Area.create req.body, (err, doc)->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        res.send 200
  # DELETE: (req, res, next)->

module.exports = (req, res, next)->
  try
    # return res.send 403 if req.user.role not in ['leader', 'admin']
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405