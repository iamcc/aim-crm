Industry = require '../models/industryModel'
Project = require '../models/projectModel'
ProjectType = require '../models/projectTypeModel'
Area = require '../models/areaModel'
async = require 'async'

method =
  GET: (req, res, next)->
    Industry.find {}, (err, docs)->
      for i in docs
        ((i)->Project.count {'industry.name': i.name}, (err, count)->
          i.projects = count
          i.save())(i)
        Project.update {'industry.name': i.name}, {'industry._id': i._id}, {multi: true}, ->

    ProjectType.find {}, (err, docs)->
      for i in docs
        ((i)->Project.count {'type.name': i.name}, (err, count)->
          i.projects = count
          i.save())(i)
        Project.update {'type.name': i.name}, {'type._id': i._id}, {multi: true}, ->

    Area.find parentName: null, (err, docs)->
      for a in docs
        ((a)->Project.count {'area.name': a.name}, (err, count)->
          a.projects = count
          a.save())(a)
        Area.update {parentName: a.name}, {parent: a._id}, {multi: true}, ->
        Project.update {'area.name': a.name}, {'area._id': a._id}, {multi: true}, ->
    Area.find parentName: $ne: null, (err, docs)->
      for c in docs
        ((c)->Project.count {'company.name': c.name}, (err, count)->
          c.projects = count
          c.save())(c)
        Project.update {'company.name': c.name}, {'company._id': c._id}, {multi: true}, ->

    res.send 200

module.exports = (req, res, next)->
  try
    method[req.method] req, res, next
  catch e
    res.send 405