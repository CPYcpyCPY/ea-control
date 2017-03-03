mongoose = require 'mongoose'

Box = null
Execution = null
io = null

# 暂时的办法，待修改
tmp-execution = null

handle-client-socket = (socket) !->
  socket.on 'join-room', (room-list) !->
    console.log 'a client join-room: ', room-list
    [socket.join(room) for room in room-list]
    # console.log('join-rooms: ' + JSON.stringify(socket.adapter.rooms))

  socket.on 'leave-room', (data) !->
    console.log 'leave-room: ', data
    [socket.leave(room) for room in data.rooms]
    # console.log('leave-rooms: ' + JSON.stringify(socket.adapter.rooms))

  socket.on 'start-test', (data) !-> # todo
    console.log 'start-test: ', data
    console.log typeof data

    new Execution data .save! .then (execution) ->
      console.log 'start-test execution: ', execution
      tmp-execution := execution
    .catch (err)!-> console.log '数据库更新错误'
    socket.broadcast.to data.ea-box._id .emit 'start-test', data.script

handle-tester-socket = (socket) !->
  box-id = ''

  socket.on 'report-id', (data) !->
    console.log 'report-id: ' + data
    console.log 'socketId: ', socket.id

    Box.find-one {id: data.id} .exec! .then (box) !->
      if box
        box-id := box._id
        console.log 'box exist and join room: ', box._id
        socket.join box._id
        # console.log 'box exist and join room: ', JSON.stringify(socket.adapter.rooms)
      else
        box = new Box {
          id: data.id
          name: data.id
          registerDate: new Date!
          workingStatus: 'idle'
          productInfo:
            rpiSerial: '8a5b572d-c314-483d-a506-f1387da4d872'
            rpiVersion: '0.0.1'
            releaseDate: new Date!
            boxVersion: '0.1.1'
        }

        box.save! .then (doc)!->
          box-id := box._id
          console.log 'box new join room: ', box._id
          socket.join doc._id
          # console.log 'box new join room: ', JSON.stringify(socket.adapter.rooms)
        .catch (err)!-> console.log 'err: ' + err

    # console.log('rooms: ' + JSON.stringify(socket.adapter.rooms))

  socket.on 'test-started', (data) !->
    console.log 'test-started'    console.log 'box-id: ' + box-id
    console.log 'time: ' + data.time

    Execution.update {'_id': tmp-execution._id}, { $set: startTime: data.time } .exec!
    .then !->
      data.execution = tmp-execution
      data.box-id = box-id
      socket.broadcast.to box-id .emit 'test-started', data
    .catch (err)!-> console.log '数据库更新错误'


  socket.on 'step-status', (data) !->
    console.log 'step-status: ', data

    data.box-id = box-id
    socket.broadcast.to box-id .emit 'step-status', data

  socket.on 'test-success', (data) !->
    console.log 'test-success: ', data
    Execution.update {'_id': tmp-execution._id}, { $set: { endTime: data.time, result: 'pass'} } .exec! .catch (err)!-> console.log '数据库更新错误'
    socket.broadcast.to box-id .emit 'test-success', data

  socket.on 'test-fail', (data) !->
    console.log 'test-fail: ', data
    Execution.update {'_id': tmp-execution._id}, { $set: { reason: {step: data.stop, err: data.err}, result: 'fail'} } .exec! .catch (err)!-> console.log '数据库更新错误'
    socket.broadcast.to box-id .emit 'test-fail', data

handle-socket = (socket) !->

  socket.emit 'has-connect', '已连接服务器'

  handle-tester-socket socket
  handle-client-socket socket

module.exports = (server) !->
  Box := mongoose.model 'Box'
  Execution := mongoose.model 'Execution'
  io := require('socket.io')(server)
  io.on 'connection', handle-socket
