mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

agentSchema = new Schema
  name: String
  
module.exports = mongoose.model 'Agent', agentSchema