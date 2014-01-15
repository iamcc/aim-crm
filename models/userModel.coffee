crypto = require 'crypto'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

userSchema = new Schema
  uname: String
  pwd: String
  realName: String
  role:
    type: String
    enum: 'supporter leader finance admin'.split(' ')

md5 = (str)->crypto.createHash('md5').update(str).digest('hex')

userSchema.path('pwd').set (str)->
  @pwd = md5 str

userSchema.statics.login = (uname, pwd, fn)->
  @findOne {uname: uname}, (err, doc)->
    if err
      console.log err      
      return fn false
    if doc and doc.pwd is md5(pwd) then fn true, doc
    else fn false
  
module.exports = mongoose.model 'User', userSchema