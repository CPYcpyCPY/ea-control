path = require 'path'

/**
 * @brief      { index页面路由定义 }
 * @author     { 王宇翔 }
 */
module.exports = (app) ->
  app.get '/', (req, res) ->
    console.log '1'
    res.send-file path.join __dirname, '../../app/index.html'
