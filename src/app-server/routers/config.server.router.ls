express = require 'express'
router = express.Router!
authentication = require '../middlewares/authentication'
box-router = require '../routers/box.server.router'
auth-router = require '../routers/auth.server.router'
plan-router = require '../routers/plan.server.router'
exe-router = require '../routers/execution.server.router'

/**
 * @brief      { 为所有数据请求的API设置路由级中间件 }
 * @author     { 王宇翔 }
 */
module.exports = (app) -> app.use '/api', router


/*
 * 挂载路由
 */
box-router router
auth-router router
plan-router router
exe-router router
