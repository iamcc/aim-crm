mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

financeSchema = new Schema
  contract:
    num: String
    date: Date
    recvDate: Date
    attachments: [String]
    payType: String
  projects: [{type: ObjectId, ref: 'Project'}]
  balance: Number
  memo: String
  payments: [{
    money: Number
    memo: String
    date: Date
  }]
  invoices: [{
    money: Number
    num: String
    memo: String
    date: Date
  }]
  notices: [{
    content: String
    date: Date
    readers: [{type: ObjectId, ref: 'User'}]
  }]

module.exports = mongoose.model 'Finance', financeSchema