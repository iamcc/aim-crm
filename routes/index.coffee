User = require '../models/userModel'

module.exports = (app)->
  auth = (req, res, next)->
    return res.send 401 if not (req.user = req.session.user)
    next()

  app.post '/login', (req, res)->
    {uname, pwd} = req.body

    User.login uname, pwd, (b, doc)->
      return res.send 401 if not b
      req.session.user = doc
      resDoc = JSON.parse JSON.stringify doc
      delete resDoc.pwd
      res.send resDoc

  app.get '/logout', (req, res)->
    req.session.destroy()
    res.redirect '/'

  app.all '/api/:mod/:_id?', auth, (req, res, next)->
    try
      require("../apis/#{req.params.mod}") req, res, next
    catch e
      console.log e
      res.send 404