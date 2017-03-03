mongoose = require 'mongoose'

User = require '../models/user.server.model'
Box = require '../models/box.server.model'
Plan = require '../models/test-plan.server.model'
Execution = require '../models/execution.server.model'

Promise = require 'bluebird'

mongoose.Promise = Promise

config = {
  db: '127.0.0.1/my-ea-control'
  # db: '172.18.180.220/ea-control'
  users: ['admin', 'liuyi', 'chener', 'zhangsan', 'lisi', 'wangwu', 'zhaoliu', 'sunqi', 'zhouba', 'wujiu', 'zhengshi']
  box-count: 10
  plan-count: 20
  execution-count: 100
}

rand = (start, end)-> Math.floor(Math.random() * end) + start

gen-fake-users = ->
  promise-list = []

  for name, index in config.users
    info = {
      username: name
      password: '12345678'
      companyName: '美的'
      role: if name is 'admin' then 'admin' else 'user'
      createDate: new Date!
    }

    promise-list.push(new User info .save! .then (doc)-> doc)

  Promise.all promise-list


gen-fake-boxes = ->
  promise-list = []

  for i from 1 to config.box-count
    info = {
      id: i
      name: '测试盒' + i
      companyName: '美的'
      registerDate: new Date!
      workingStatus: if Math.random() > 0.5 then 'busy' else 'idle'
      productInfo:
        rpiSerial: '8a5b572d-c314-483d-a506-f1387da4d872'
        rpiVersion: '0.0.1'
        releaseDate: new Date!
        boxVersion: '0.1.1'
    }

    promise-list.push(new Box info .save! .then (doc)-> doc)

  Promise.all promise-list

gen-fake-plans = (users, boxes)->
  promise-list = []

  for i from 1 to config.plan-count
    info = {
      name: if Math.random! < 0.1 then 'rapid测试'
            else if Math.random! < 0.2 then '普通洗涤测试'
            else if Math.random! < 0.3 then 'intensive测试'
            else if Math.random! < 0.4 then 'Extra Hygiene洗涤测试'
            else if Math.random! < 0.6 then 'Extra drying洗涤测试'
            else if Math.random! < 0.8 then 'Express洗涤测试'
            else '自动洗洗涤测试'
      type: '初期'
      companyName: '美的'
      docCreateDate: new Date()
      manualOperationFrequency: rand(1, 30)
      stepCount: rand(1, 10)
      status: if Math.random() > 0.5 then 'editable' else 'executable'
      scriptCreateDate : new Date()
      expectedExecuteDuration : rand(1000, 10000)
      usedFrequency: rand(1, 10)
      steps: [
        {name: '排水'          ,expectedStepDuration: 45000}
        {name: '进水'          ,expectedStepDuration: 0      ,capacity: '4L'}
        {name: '频率检测'       ,expectedStepDuration: 0}
        {name: '高速洗涤'       ,expectedStepDuration: 300000}
        {name: '排水'          ,expectedStepDuration: 45000}
      ]
      scriptCreator:
        _id: ''
        username: ''
      script:
        test-package  : 'driven-test-plans'
        package-name  : '../node_modules/midea-kitchen-tests/bin/b36'
        test-name     : 'soak'
      docCreator:
        _id: ''
        username: ''
      doc:
        docName: 'reboot.ei6'
        docUrl: 'http://邓.org'
    }

    random-user = users[rand(0, users.length - 1)]
    info.scriptCreator._id = random-user._id
    info.scriptCreator.username = random-user.username

    random-user = users[rand(0, users.length - 1)]
    info.docCreator._id = random-user._id
    info.docCreator.username = random-user.username

    promise-list.push(new Plan info .save! .then (doc)-> doc)

  Promise.all promise-list .then (plans)-> [users, boxes, plans]

gen-fake-executions = (users, boxes, plans)->
  promise-list = []

  for i from 1 to config.execution-count
    info =  {
      name: ''
      testPlan:
        _id: ''
        name: ''
      eaBox:
        _id: ''
        name: ''
      executionCreator:
        _id: ''
        username: ''
      startTime: new Date!
      endTime: new Date!
      result: if Math.random() > 0.6 then 'pass' else if Math.random() > 0.6 then 'fail' else ''
      comment: 'test'
      stepExecuteDetail:
        * _id: 2
          name: '排水'
          timeUsed: 5000
          status: 'ended'
          result: 'Pass'
        * _id: 3
          name: '近视'
          timeUsed: 6000
          status: 'ended'
          result: 'Pass'
    }

    plans = plans.filter (plan)-> plan.status === 'executable'

    random-plan = plans[rand(0, plans.length - 1)]
    info.testPlan._id = random-plan._id
    info.testPlan.name = random-plan.name

    random-box = boxes[rand(0, boxes.length - 1)]
    info.eaBox._id = random-box._id
    info.eaBox.name = random-box.name

    random-user = users[rand(0, users.length - 1)]
    info.executionCreator._id = random-user._id
    info.executionCreator.username = random-user.username

    if info.result === '' then info.endTime = ''

    promise-list.push(new Execution info .save! .then (doc)-> doc)

  Promise.all promise-list

get-remove-promise = (model)-> model.remove {} .exec!

remove-previous-data = ->
  models = [User, Box, Plan, Execution]
  promise-list = models.map (model)-> get-remove-promise model
  Promise.all promise-list

gen-fake-data = !->
  db = mongoose.connect config.db

  mongoose.connection.on 'open', !-> console.log 'connect'
  mongoose.connection.on 'error', !-> console.log 'Connection connected fail'

  remove-previous-data! .then !->
    Promise.all [gen-fake-users!, gen-fake-boxes!]
    .then ([users, boxes])-> gen-fake-plans users, boxes
    .then ([users, boxes, plans])-> gen-fake-executions users, boxes, plans
    .then (executions)!-> mongoose.disconnect!
    .catch (err)!-> console.log 'err: ' + err


gen-fake-data!
