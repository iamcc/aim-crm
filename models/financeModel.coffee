mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
ID = require './idModel'

financeSchema = new Schema
  contract:
    num: String
    date: Date
    price: Number
    client: String
    recvDate: Date
    attachments: [String]
    payType: String
  projects: [{type: ObjectId, ref: 'Project'}]
  balance: type: Number, default: 0
  memo: String
  payments: [{
    money: Number
    memo: String
    date: Date
  }]
  invoices: [{
    num: String
    money: Number
    memo: String
    date: Date
  }]
  notices: [{
    content: String
    date: Date
    readers: [{type: ObjectId, ref: 'User'}]
  }]

financeSchema.pre 'validate', (next)->
  self = @
  prefix = 'HT'
  ID.getID prefix, (err, doc) ->
    return next err if err
    self.contract.num = String(doc.count)
    while self.contract.num.length < 6
      self.contract.num = '0' + self.code
    self.contract.num = prefix + self.contract.num
    next()

module.exports = mongoose.model 'Finance', financeSchema