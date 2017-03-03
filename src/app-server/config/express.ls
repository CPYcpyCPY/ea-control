express = require 'express'
body-parser = require 'body-parser'
path = require 'path'
method-override = require 'method-override'
cookie-parser = require 'cookie-parser'
session = require 'express-session'
authentication = require '../middlewares/authentication'

/**
 * @brief      向外输出一系列配置好中间件的express应用
 *
 * @return     { Object }  express应用
 */
module.exports = ->
  app = express!
  set-express-middleware app
  set-express-route app
  # set-express-auth app
  app


/**
 * @brief      设置express应用路由
 *
 * @param      express 应用
 *
 */
set-express-route = (app) !->
  require('../routers/config.server.router') app
  require('../routers/index.server.router') app

/**
 * @brief      设置express应用级中间件
 *
 * @param      express 应用
 *
 */
set-express-middleware = (app) !->

  app.use cookie-parser!
  app.use session {
    name: 'ats-session-id'
    secret: 'what-a-lovely-day-so-just-enjoy-coding'
    resave: true
    saveUninitialized: true
    cookie: {
      max-age: 5 * 60 * 1000
    }
  }

  app.use body-parser.urlencoded({ extended: true })
  app.use body-parser.json!
  app.use method-override!
  app.use express.static path.join __dirname, '../../'


/**
 * @brief      session验证用户是否登录（暂未使用这部分代码）
 *
 * @author     王宇翔
 */
set-express-auth = (app) !->
  app.all '/*', (req, res, next) ->
    if req.path != '/' && !req.path != '/api/login' && !req.session.user
      return res.json {
        status: 'NOT_AUTHENTICATIC'
        msg: '未登录'
        is-logined: false
      }
    else
      next!

