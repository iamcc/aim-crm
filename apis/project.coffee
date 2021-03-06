Area = require '../models/areaModel'
Industry = require '../models/industryModel'
Project = require '../models/projectModel'
ProjectType = require '../models/projectTypeModel'
ClientType = require '../models/clientModel'
_ = require 'underscore'
async = require 'async'
helper = require '../commons/helper'

method =
  GET: (req, res, next) ->
    if _id = req.params._id
      Project.findById _id, (err, doc) ->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        res.send doc
    else if req.query.type is 'client'
      Project.find {$and:['client._id': req.query.kw, contractNum: null]}, null, {limit: 10}, (err, docs) ->
        return next err if err
        res.send docs
    else if req.query.type is 'search'
      keyword = new RegExp(req.query.keyword)
      req.query.condition =
        $or: [
          {name: keyword}
          {tags: keyword}
          {'sales.name': keyword}
          {'view.name': keyword}
        ]

      helper.getPage Project, req.query, (err, data) ->
        return next(err) if err
        res.send data
    else
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

      num = query.num or 10
      page = query.page or 1
      opts =
        skip: (page - 1) * num
        limit: num
        sort: '-_id'

      async.auto {
        count: (cb) ->
          Project.count condition, cb
        list: (cb) ->
          Project.find condition, null, opts, cb
      } ,
      (err, rst) ->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        res.send {
          count: rst.count
          totalPage: Math.ceil rst.count / num
          list: rst.list
        }

  PUT: (req, res, next) ->
    return res.send 400 if not (_id = req.params._id)
    _id = req.body._id
    delete req.body._id
    if req.body.comment
      comment =
        content: req.body.content
        creator: req.user.realname
        date: new Date()
        status: req.body.status
      Project.update {_id: _id}, {$push: {comments: comment}}, (err, num)->
#        return res.send 500 if err
        return next(err) if err
        res.send comment
    else
      Project.findById _id, (err, doc)->
        return res.send 404 unless doc
        if req.body.area
          Area.findByIdAndUpdate req.body.area._id, {$inc: projects: 1}, ->
          Area.findByIdAndUpdate doc.area._id, {$inc: projects: -1}, ->
        if req.body.company
          Area.findByIdAndUpdate req.body.company._id, {$inc: projects: 1}, ->
          Area.findByIdAndUpdate doc.company._id, {$inc: projects: -1}, ->
        if req.body.industry
          Industry.findByIdAndUpdate req.body.industry._id, {$inc: projects: 1}, ->
          Industry.findByIdAndUpdate doc.industry._id, {$inc: projects: -1}, ->
        if req.body.type
          ProjectType.findByIdAndUpdate req.body.type._id, {$inc: projects: 1}, ->
          ProjectType.findByIdAndUpdate doc.type._id, {$inc: projects: -1}, ->
        if(req.body.status)
          if req.body.status is '初始资料'
            doc.deadline = new Date()
            doc.deadline.setHours(doc.deadline.getHours() + 24*3)
          if req.body.status is '上线'
            doc.online.date = new Date()
            doc.online.reviewer = req.user
          doc.comments.push {
            content: req.body.status
            creator: req.user.realname
            status: doc.status
          }
        if(req.body.supporter)
          doc.comments.push {
            content: '客服更改为：'+req.body.supporter.realname
            creator: req.user.realname
            status: doc.status
          }
          doc.assignDate = new Date
        if req.body.agent
          req.body.price = 0
          for p in req.body.agent.products
            req.body.price += p.price * (p.num or 0)
        _.extend doc, req.body
        doc.save (err)->
#          return res.send 500 if err
          return next(err) if err
          res.send 200
  POST: (req, res, next) ->
    delete req.body._id
    # if req.body.agent
    #   req.body.price = 0
    #   for p in req.body.agent.products
    #     req.body.price += p.price * (p.num or 0)

    doc = new Project req.body
    doc.comments.push {
      content: '创建项目, 客服：'+(doc.supporter and doc.supporter.realname or '')
      creator: req.user.realname
      status: doc.status
    }
    doc.assignDate = new Date if doc.supporter
    doc.save (err, doc) ->
#      if err
#        console.log err
#        return res.send 500
      return next(err) if err
      if req.body.area
        Area.findByIdAndUpdate req.body.area._id, {$inc: projects: 1}, ->
      if req.body.company
        Area.findByIdAndUpdate req.body.company._id, {$inc: projects: 1}, ->
      if req.body.industry
        Industry.findByIdAndUpdate req.body.industry._id, {$inc: projects: 1}, ->
      if req.body.type
        ProjectType.findByIdAndUpdate req.body.type._id, {$inc: projects: 1}, ->

      res.send 200
  DELETE: (req, res, next) ->
    res.send 400 unless (_id = req.params._id)
    Project.findByIdAndRemove _id, (err) ->
#      if err
#        console.log err
#        return res.send 500
      return next(err) if err
      res.send 200

module.exports = (req, res, next) ->
  try
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405