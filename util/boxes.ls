jsf = require 'json-schema-faker'
fs = require 'fs'
jsf.extend 'faker', (faker)->
  faker.locale = 'zh_CN'
  faker

schema =
  $schema: 'http://json-schema.org/draft-04/schema#',
  title: 'Box',
  description: 'generate box mock data',
  type: 'object'
  properties:
    _id:
      type: 'integer'
      minimum: 1
    name:
      type: 'string'
      pattern: '^测试盒[a-z]-[0-9]$'
      # faker: 'commerce.productName'
      # max-length: 10
    company-id: type: 'integer', minimum: 1, maximum: 4
    product-info:
      type: 'object'
      properties:
        rpi-serial:
          type: 'string'
          faker: 'random.uuid'
        rpi-version: enum: ['0.0.1']
        release-date:
          type: 'string'
          format: 'date-time'
        ea-box-version: enum: ['0.1.1']
      required: ['rpiSerial','rpiVersion', 'releaseDate', 'eaBoxVersion']
    working-status: enum: ['闲置', '使用中']
    out-of-date-time:
      type: 'string'
      format: 'date-time'
    registe-date:
      type: 'string'
      format: 'date-time'
    pins-can-wire: type: 'integer', minimum: 5, maximum: 8
#===== 非持久化 =====
    billing-status: enum: ['in-service', 'out-of-date', 'not-used']
#==================
  required: ['_id', 'name', 'companyId', 'productInfo', 'workingStatus', 'outOfDateTime', 'registeDate', 'pinsCanWire', 'billingStatus']


boxes = [(jsf schema) for i in [1 to 30]]

fs.write-file-sync __dirname + '/../src/app/data/boxes.json', JSON.stringify {boxes}



