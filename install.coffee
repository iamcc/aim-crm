Agent = require './models/agentModel'
Industry = require './models/industryModel'
Project = require './models/projectModel'
ProjectType = require './models/projectTypeModel'
Area = require './models/areaModel'
Sales = require './models/salesModel'
User = require './models/userModel'
Client = require './models/clientModel'
async = require 'async'

method =
  GET: (req, res, next)->
    return res.send 404

#    User.create {
#      uname: 'admin'
#      pwd: '1'
#      realname: '超级管理员'
#      role: 'admin'
#    }
#    , (err, user) ->
#      console.log(err)
#      console.log(user)
#    return res.send 200


#    Client.find {}, (err, docs) ->
#      for c in docs
#        Project.update {'client.code': c.code}, {'client._id': c._id}, {multi: true}, (err, num) ->
#          console.log err, num
#    return res.send 200

    Project.find().distinct 'client', (err, docs) ->
      q = async.queue(
        (task, cb) -> task cb
        1
      )
      for c in docs
        if c isnt null and c.trim() isnt '' and c.trim() isnt 'null'
          ((c) -> q.push (cb) ->
            Client.create {name: c}, (err, doc) ->
              Project.update {client: c}, {client: doc}, {multi: true}, (err, num) ->
                console.log err, num
                cb()
          )(c)

    return res.send 200

    Agent.find {}, (err, docs)->
      for a in docs
        Project.update {'agent.name': a.name}, {'agent._id': a._id}, {multi: true}, ->

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

    q = async.queue(
      (task, cb) -> task.run cb
      10
    )

    Area.find parentName: null, (err, docs)->
      for a in docs
        ((a) ->
            Project.count {'area.name': a.name}, (err, count)->
              a.projects = count
              a.save()
            q.push {
              run: (cb) -> Area.update {parentName: a.name}, {parent: a._id}, {multi: true}, cb
            }
            q.push {
              run: (cb) -> Project.update {'area.name': a.name}, {'area._id': a._id}, {multi: true}, cb
            }
        )(a)

    Area.find parentName: $ne: null, (err, docs)->
      for a in docs
        ((a) ->
            Project.count {'company.name': a.name}, (err, count)->
              a.projects = count
              a.save()
            q.push {
              run: (cb) -> Project.update {'company.name': a.name}, {'company._id': a._id}, {multi: true}, cb
            }
        )(a)

      q.drain = ->
        console.log '分公司去重复'

        Project.find().distinct 'company._id', (err, docs) ->
          Area.remove {
            $and:[
              parentName: $ne: null
              _id: $nin: docs
            ]
          }, (err, num) ->
            Sales.find {}, (err, docs) ->
              for s in docs
                ((s) ->
                  q.push {
                    run: (cb) ->
                      async.parallel(
                        {
                          company: (cb) -> Area.findOne {parentName: {$ne: null}, name: s.company.name}, cb
                          manager: (cb) -> Sales.findOne {name: s.company.manager.name}, cb
                        }
                        (err, rst) ->
                          s.company._id = rst.company._id
                          s.company.manager._id = rst.manager._id
                          s.company.parent = rst.company.parent
                          s.save (err) ->
                            Project.update {'sales.name': s.name}, {'sales._id': s._id, 'company.manager._id': rst.manager._id, 'company.manager.name': rst.manager.name}, {multi: true}, cb
                      )
                })(s)

              q.drain = ->
                console.log '销售去重复'

#                Project.find {}, (err, docs) ->
#                  for p in docs
#                    Sales.remove {
#                      $or: [
#                        $and: [
#                          name: p.sales.name
#                          _id: $ne: p.sales._id
#                        ]
#                        $and: [
#                          name: p.company.manager.name
#                          _id: $ne: p.company.manager._id
#                        ]
#                      ]
#                    }, (err, num) ->
#                      console.log err, num
#
#                Area.find parentName: null, (err, docs) ->
#                  docs = (d.name for d in docs)
#                  Sales.remove {'company.parentName': $nin: docs}, (err, num) ->
#                    console.log err, num


    res.send 200

module.exports = (req, res, next)->
  try
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405