mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

areaSchema = new Schema
  name: String
  managers: [{type: ObjectId, ref: 'Sales'}]
  companies: [{
    name: String
    teams: [{
      leader: type: ObjectId, ref: 'Sales'  
      sales: [{type: ObjectId, ref: 'Sales'}]
    }]  
  }]

module.exports = mongoose.model 'Area', areaSchema