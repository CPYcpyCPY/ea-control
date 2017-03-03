execution = require '../controllers/execution.server.controller'

/**
 * @brief      { 配置和测试执行有关API的路由 }
 * @param      <router>   { 上一级路由处设置的中间件，以下路由配置挂载在上面 }
 * @author     { 王宇翔 }
 */
module.exports = (router) ->
  router.get '/executions/:id', execution.retrieve-execution-by-id
