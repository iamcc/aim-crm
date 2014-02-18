Finance = require '../models/financeModel'
Project = require '../models/projectModel'
async = require 'async'
helper = require '../commons/helper'
_ = require 'underscore'
fs = require 'fs'

method =
  GET: (req, res, next) ->
    if req.params._id
      Finance
        .findById(req.params._id)
        .populate('projects')
        .exec (err, doc) ->
          return next err if err
          res.send doc
    else
      switch req.query.type
        when 'all' then req.query.condition = {}
        when 'unpay' then req.query.condition = balance: $gt: 0
        when 'paied' then req.query.condition = balance: 0
        else req.query.condition = {}
      helper.getPage Finance, req.query, (err, data) ->
        return next(err) if err
        res.send data
  POST: (req, res, next) ->
    delete req.body._id

    if req.params._id
      if req.query.act is 'upload'
        uploadFolder = __dirname + '/../public/uploads/' + req.params._id + '/'
        fs.mkdirSync uploadFolder unless fs.existsSync uploadFolder
        fs.renameSync req.files.file.path, uploadFolder + req.files.file.name
        res.send '/uploads/' + req.params._id + '/' + req.files.file.name
      else
        Finance.findById req.params._id, (err, doc) ->
          return next err if err
          return res.send 404 unless doc
          oldPids = (p for p in doc.projects) #原项目ID
          _.extend doc, req.body
          newPids = [] #新项目ID
          for pid in doc.projects #更新项目的合同号
            newPids.push pid
            Project.update _id: pid, {contractNum: doc.contract.num}, (err, doc) ->
              console.log err, doc

          for pid in oldPids #恢复被剔除项目的合同号
            if pid not in newPids
              Project.update _id: pid, {contractNum: null}, (err, doc) ->
                console.log err, doc

          doc.save (err) ->
            return next err if err
            res.send 200
    else
      newDoc = new Finance(req.body)
      newDoc.save (err) ->
        return next err if err
        for pid in newDoc.projects #更新项目的合同号
          Project.update _id: pid, {contractNum: newDoc.contract.num}, (err, doc) ->
            console.log err, doc
        res.send 200

module.exports = (req, res, next) ->
  try
    return res.send 403 if req.user.role not in ['finance', 'admin']
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405