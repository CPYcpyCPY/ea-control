jsf = require 'json-schema-faker'
fs = require 'fs'
jsf.extend 'faker', (faker)->
  faker.locale = 'zh_CN'
  faker

schema =
  $schema: 'http://json-schema.org/draft-04/schema#',
  title: 'User',
  description: 'generate user mock data',
  type: 'object'
  properties:
    _id:
      type: 'integer'
      minimum: 1
    username:
      type: 'string'
      faker: 'name.findName'
    password: enum: ['12345678']
    company: enum: ['美的', '格力', '海尔']
    role: enum: ['管理员', '测试员', '负责人']
    createTime:
      type: 'string'
      format: 'date-time'
    is-online:
      type: 'boolean'
  required: ['_id', 'password', 'username', 'company', 'role', 'createTime', 'is-online']


users = [(jsf schema) for i in [1 to 20]]

fs.write-file-sync __dirname + '/../src/app/data/users.json', JSON.stringify {users}



