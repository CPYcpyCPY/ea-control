mongoose = require('mongoose')
User = mongoose.model('User')
{send-data, handle-error} = require '../utils/utils'

/**
 * @brief      验证登录并返回用户信息（以后对password加密）
 */
exports.login = (req, res) !->
  {username, password} = req.body
  User.find-one {username} .exec! .then (result) ->
    if result and result.password is password
      user = {
        _id: result._id
        username: result.username
        company-name: result.company-name
        role: result.role
      }
      send-data res, 'OK', user, '用户登录验证成功'
    else
      send-data res, 'WRONG_USERNAME_OR_PASSWORD', null, '用户名或密码错误'
  .catch (err) ->
    handle-error res, 'DATABASE_QUERY_ERROR', err, '数据库查询错误'


/**
 * @brief      { 用户登录操作 }
 *
 * @return     { OK状态 }
 */
# exports.logout = (req, res)!->
#   req.session.user = null
#   send-data res, 'OK', null, '用户退出登录成功'



/**
 * @brief      Determines if logined.
 *
 * @return     True if logined, False otherwise.
 */
# exports.isLogined = (req, res)!->
#   if req.session.user
#     res.json {
#       status: 'OK'
#       user:
#           username: req.session.user.username
#           company-name: req.session.user.company-name
#           role: req.session.user.role
#       is-logined: true
#     }
#   else
#     res.json {
#       status: 'NOT_AUTHENTICATION'
#       is-logined: false
#     }
