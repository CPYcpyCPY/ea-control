jsf = require 'json-schema-faker'
fs = require 'fs'
jsf.extend 'faker', (faker)->
  faker.locale = 'zh_CN'
  faker

boxes = JSON.parse fs.read-file-sync __dirname + '/../src/app/data/boxes.json'
box-ids = []
box-names = []
for item in boxes.boxes
  box-ids.push item._id
  box-names.push item.name

users = JSON.parse fs.read-file-sync __dirname + '/../src/app/data/users.json'
test-creator-ids = []
test-creator-names = []
for item in users.users
  test-creator-ids.push item._id
  test-creator-names.push item.username

plans = JSON.parse fs.read-file-sync __dirname + '/../src/app/data/test-plans.json'
test-plan-ids = []
test-plan-names = []
for item in plans.test-plans
  test-plan-ids.push item._id
  test-plan-names.push item.name

schema =
  $schema: 'http://json-schema.org/draft-04/schema#',
  title: 'Execution',
  description: 'generate execution mock data',
  type: 'object'
  properties:
    _id: type: 'integer', minimum: 1
    name: enum: ['b36自动洗测试', 't121双速洗测试']
    test-plan:
      type: 'object'
      properties:
        _id: enum: test-plan-ids
        name: enum: ['b36自动洗测试计划脚本', 't121双速洗测试计划脚本']
      required: ['_id', 'name']
    box:
      type: 'object'
      properties:
        _id: enum: box-ids
        name: enum: box-names
      required: ['_id', 'name']
    test-creator:
      type: 'object'
      properties:
        _id: enum: test-creator-ids
        name: enum: test-creator-names
      required: ['_id', 'name']
    data:
      type: 'object'
      properties:
        steps: ['unknow rows']
    start-time: type: 'string', format: 'date-time'
    end-time: type: 'string', format: 'date-time'
    result: enum: ['Pass', 'Fail']
    comment: '这里要填写备注'
#===== 非持久化 =====

    guide:
      type: 'object'
      properties:
        # pins: id, name，这里未完善
        pins: enum: [[1,2,4,5,6], [2,3,4,5,6], [1,4,5,6]]
      required: ['pins']
    steps-count: type: 'integer', minimum: 15, maximum: 45
    status: enum: ['开始测试', '测试开始', '测试执行中', '测试结束']

#==================
  required: ['_id', 'name', 'testPlan', 'box', 'data', 'testCreator', 'startTime', 'endTime', 'result', 'guide', 'stepCount', 'status']


executions = [(jsf schema) for i in [1 to 30]]

fs.write-file-sync __dirname + '/../src/app/data/executions.json', JSON.stringify {executions}



