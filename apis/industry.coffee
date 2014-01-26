Industry = require '../models/industryModel'
Project = require '../models/projectModel'
async = require 'async'

method =
  GET: (req, res, next)->
    Industry.find {}, null, {sort: '-_id'}, (err, docs)->
      if err
        console.log err
        return res.send 500
      res.send docs
  POST: (req, res, next)->
    async.auto {
      count: (cb)->
        Industry.count {name: req.body.name}, cb
      data: [
        'count'
        (cb, rst)->
          if rst.count > 0 then return res.send 400, '行业已经存在'
          Industry.create {name: req.body.name}, cb
      ]
    },
    (err, rst)->
      if err
        console.log err
        return res.send 500
      res.send 200
  DELETE: (req, res, next)->
    return res.send 400 unless (_id = req.params._id)

    Industry.findById _id, (err, doc)->
      if err
        console.log err
        return res.send 500
      return res.send 404 unless doc
      return res.send 500, '行业已被使用，不能删除' if doc and doc.projects > 0
      doc.remove()
      res.send 200

module.exports = (req, res, next)->
  try
    return res.send 403 if req.user.role not in ['leader', 'admin']
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405