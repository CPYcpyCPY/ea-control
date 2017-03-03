jsf = require 'json-schema-faker'
fs = require 'fs'
jsf.extend 'faker', (faker)->
  faker.locale = 'zh_CN'
  faker

schema =
  $schema: 'http://json-schema.org/draft-04/schema#',
  title: 'Company',
  description: 'generate company mock data',
  type: 'object'
  properties:
    _id:
      type: 'integer'
      minimum: 1
    name: enum: ['美的', '格力', '海尔']
    manager-name:
      type: 'string'
      faker: 'name.findName'
    manager-email:
      type: 'string'
      format: 'email'
      faker: 'internet.email'
    create-time:
      type: 'string'
      format: 'date-time'
#===== 非持久化 =====
    user-count:
      type: 'integer'
      minimum: 1
      maximum: 10
    user-online-percentage: enum: ['15%', '36%', '42%', '23%']
    box-used-percentage: enum: ['67%', '23%', '87%', '46%']
#==================
  required: ['_id', 'name', 'managerName', 'managerEmail', 'createTime', 'userCount', 'userOnlinePercentage', 'boxUsedPercentage']


companies = [(jsf schema) for i in [1 to 3]]

fs.write-file-sync __dirname + '/../src/app/data/companies.json', JSON.stringify {companies}



