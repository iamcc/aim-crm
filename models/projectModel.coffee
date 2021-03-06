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
  status: type: String, default: '新建', enum: '新建 首次催单 二次催单 初始资料 搁置 录入 完成 一次修改 上线 毁约'.split(' ')
  supporter:
    _id: ObjectId
    realname: String
  tags: [String]
  agent:
    _id: ObjectId
    name: String
    products: [{
      _id: ObjectId
      name: String
      unit: String
      price: Number
      num: Number
    }]
  price: Number
  buyYear: Number
  client:
    _id: ObjectId
    code: String
    name: String
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
      realname: String
  memo: String
  comments: [{
    content: String
    creator: String
    date: type: Date, default: Date.now
    status: String
    modify: String
  }]
  contractNum: String
  view:
    catalog: String
    name: String
  deadline   : Date
  assignDate : Date

# exports.Project = mongoose.model 'Project', projectSchema
# exports.projectSchema = projectSchema
module.exports = mongoose.model 'Project', projectSchema