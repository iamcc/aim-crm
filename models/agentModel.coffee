mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

agentSchema = new Schema
  name: String
  
# exports.Agent = mongoose.model 'Agent', agentSchema
# exports.agentSchema = agentSchema
module.exports = mongoose.model 'Agent', agentSchema