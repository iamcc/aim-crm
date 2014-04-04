mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

agentSchema = new Schema
  name: String
  people: String
  phone: String
  projects: type: Number, default: 0
  products: [{
    _id: ObjectId
    name: String
    unit: String
    price: Number
  }]
  
module.exports = mongoose.model 'Agent', agentSchema