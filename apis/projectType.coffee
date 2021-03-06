ProjectType = require '../models/projectTypeModel'
async = require 'async'

method =
  GET: (req, res, next)->
    ProjectType.find {}, null, {sort:'name'}, (err, docs)->
#      if err
#        console.log err
#        return res.send 500
      return next(err) if err
      res.send docs
  POST: (req, res, next)->
    return res.send 403 if req.user.role not in ['leader', 'admin']
    async.auto {
      count: (cb)-> ProjectType.count {name: req.body.name}, cb
      save: ['count', (cb, rst)->
        return res.send 500, '项目类型已经存在' if rst.count > 0
        ProjectType.create {name: req.body.name}, cb
      ]
    },
    (err, rst)->
#      if err
#        console.log err
#        return res.send 500
      return next(err) if err
      res.send 200
  DELETE: (req, res, next)->
    return res.send 403 if req.user.role not in ['leader', 'admin']
    ProjectType.findById req.params._id, (err, doc)->
      return next(err) if err
      return res.send 404 unless doc
      return res.send 500, '项目类型已经被使用，不能删除' if doc.projects > 0
      doc.remove()
      res.send 200        

module.exports = (req, res, next)->
  try
    # return res.send 403 if req.user.role not in ['leader', 'admin']
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405