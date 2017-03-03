user = require '../controllers/user.server.controller'

/**
 * @brief      { 配置和用户验证有关API的路由 }
 * @param      <router>   { 上一级路由处设置的中间件，以下路由配置挂载在该router上 }
 */
module.exports = (router) ->
  router.post '/login', user.login
  # router.post '/logout', user.logout
  # router.get '/isLogined', user.isLogined
