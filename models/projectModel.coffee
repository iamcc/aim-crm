mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

projectSchema = new Schema
  name: String
  type:
    _id: ObjectId
    name: String
  sales:
    _id: ObjectId
    name: String
  area:
    _id: ObjectId
    name: String
  company:
    _id: ObjectId
    name: String
    manager:
      _id: ObjectId
      name: String
  industry:
    _id: ObjectId
    name: String
  status: String
  supporter:
    _id: ObjectId
    realname: String
  tags: [String]
  agent:
    _id: ObjectId
    name: String
  price: Number
  buyYear: Number
  client: String
  orderDate: Date
  mae:
    account: String
    pwd: String
    creator:
      _id: ObjectId
      realname: String
  wx:
    account: String
    pwd: String
    wxType: String
  ec:
    id: Number
    sendBoxDate: Date
  online:
    date: Date
    reviewer:
      _id: ObjectId
      name: String
  memo: String
  comments: [{
    content: String
    creator: String
    date: type: Date, default: Date.now
    status: String
  }]

# exports.Project = mongoose.model 'Project', projectSchema
# exports.projectSchema = projectSchema
module.exports = mongoose.model 'Project', projectSchema