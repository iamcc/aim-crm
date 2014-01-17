mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
salesSchema = require('./salesModel').salesSchema
industrySchema = require('./industryModel').industrySchema
userSchema = require('./userModel').userSchema
agentSchema = require('./agentModel').agentSchema

projectSchema = new Schema
  name: String
  type: String
  sales: salesSchema
  industry: industrySchema
  status: String
  supporter: userSchema
  tags: [String]
  agent: agentSchema
  price: Number
  buyYear: Number
  client: String
  orderDate: Date
  mae:
    account: String
    pwd: String
    creator: userSchema
  wx:
    account: String
    pwd: String
    type: String
  ec:
    id: Number
    sendBoxDate: Date
  online:
    date: Date
    reviewer: userSchema
  memo: String

exports.Project = mongoose.model 'Project', projectSchema
exports.projectSchema = projectSchema