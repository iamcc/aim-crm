mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
# salesSchema = require('./salesModel').salesSchema
# industrySchema = require('./industryModel').industrySchema
# userSchema = require('./userModel').userSchema
# agentSchema = require('./agentModel').agentSchema

projectSchema = new Schema
  name: String
  type: String
  sales:
    _id: ObjectId
    name: String
  area:
    _id: ObjectId
    name: String
  company:
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
    type: String
  ec:
    id: Number
    sendBoxDate: Date
  online:
    date: Date
    reviewer:
      _id: ObjectId
      name: String
  memo: String

# exports.Project = mongoose.model 'Project', projectSchema
# exports.projectSchema = projectSchema
module.exports = mongoose.model 'Project', projectSchema