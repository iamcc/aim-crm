crypto = require 'crypto'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

userSchema = new Schema
  uname: String
  pwd: String
  realname: String
  role:
    type: String
    enum: 'supporter leader finance admin'.split(' ')
    default: 'supporter'

md5 = (str)->crypto.createHash('md5').update(str).digest('hex')

userSchema.path('pwd').set (str)->
  md5 str

userSchema.methods.exists = (fn)->
  @model('User').count {uname: @uname}, (err, num)->fn err, !!num

userSchema.statics.login = (uname, pwd, fn)->
  @findOne {uname: uname}, (err, doc)->
    if err
      console.log err      
      return fn false
    if doc and doc.pwd is md5(pwd) then fn true, doc
    else fn false
  
# exports.User = mongoose.model 'User', userSchema
# exports.userSchema = userSchema
module.exports = mongoose.model 'User', userSchema