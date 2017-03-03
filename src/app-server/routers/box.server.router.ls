express = require 'express'
box = require '../controllers/box.server.controller'
router = express.Router!


/**
 * @brief      { 配置和测试盒有关API的路由 }
 * @param      <router>   { 上一级路由处设置的中间件，以下路由配置挂载在上面 }
 */
module.exports = (router) ->
  router.get '/boxes', box.retrieve-boxes
  router.get '/boxes/:boxId', box.retrieve-box-by-id
