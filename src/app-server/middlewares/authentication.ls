/**
 * @brief      { 验证会话是否过期 }
 * @return     { 进入下一个处理函数 }
 * @author     { 王宇翔 }
 */
exports.session-auth = (req, res, next) ->
  if res.session && res.session.user
    console.log 'LOG IN.'
    next!
  else
    res.json {
      status: "NOT_LOGIN"
      is-logined: false
    }

