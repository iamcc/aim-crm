mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

projectSchema = new Schema
  name: String
  type: String
  sales: type: ObjectId, ref: 'Sales'
  industry: type: ObjectId, ref: 'Industry'
  status: String
  supporter: type: ObjectId, ref: 'User'
  tags: [String]
  agent: type: ObjectId, ref: 'Agent'
  price: Number
  buyYear: Number
  client: String
  orderDate: Date
  mae:
    account: String
    pwd: String
    creator: obj: type: ObjectId, ref: 'User'
  wx:
    account: String
    pwd: String
    type: String
  ec:
    id: Number
    sendBoxDate: Date
  online:
    date: Date
    reviewer: type: ObjectId, ref: 'User'
  memo: String

module.exports = mongoose.model 'Project', projectSchema