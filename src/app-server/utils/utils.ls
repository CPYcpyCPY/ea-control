/**
 * @brief      { 使用该函数发送相应到客户端 }
 *
 * @return     { 客户端应该收到的数据 }
 * @author     { 王宇翔 }
 */
exports.send-data = (res, status, data, msg) ->
  time = new Date!
  res.json { status, data, time, msg }



/**
 * @brief      { 查询数据抛出异常时使用这个函数发送错误响应 }
 *
 * @return     { 客户端应该收到的数据 }
 * @author     { 王宇翔 }
 */
exports.handle-error = (res, status, err, msg) ->
  time = new Date!
  if err
    console.error err
  else
    throw new Error 'handleError 传入的 err 为 null!'
  res.json { status, data: null, time, msg }
