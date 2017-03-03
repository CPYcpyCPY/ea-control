# 测试计划, 使用json-schema-faker
jsf = require 'json-schema-faker'
fs = require 'fs'
jsf.extend 'faker', (faker)->
	faker.locale = 'zh_CN'
	faker

amount = 15
mapping =
	chance-date:
		type: 'string'
		chance:
			date:
				string: true

	fakerUUID:
		type: 'string'
		faker: 'random.uuid'

	faker-url:
		type: 'string', faker: 'internet.url'

	custom-integer:
		type: 'integer'
		minimum: 0
		maximum: 100

schema =
	$schema: 'http://json-schema.org/draft-04/schema#',
	title: 'Test plan',
	description: 'generate test-plan mock data',
	type: 'object'
	properties:
		_id: mapping.fakerUUID
		company-id: type: 'integer', minimum: 1, maximum: 3
		type: enum: ['初期', '中期', '后期']
		name: enum: ['b36自动洗测试计划脚本', 't121双速洗测试计划脚本']
		doc:
			type: 'object'
			properties:
				doc-name: type: 'string', faker: 'system.fileName'
				doc-url: mapping.faker-url
			required: ['docName', 'docUrl']
		doc-created-time: mapping.chance-date
		doc-creator:
			type: 'object'
			properties:
				_id: mapping.fakerUUID
				name: type: 'string', faker: 'name.findName'
			required: ['_id', 'name']
		manual-operation-count:
			type: 'integer'
			minimum: 0
			maximum: 100
		status: enum: ['待编辑', '可执行']
		script-created-time: mapping.chance-date
		script-creator:
			type: 'object'
			properties:
				_id: mapping.fakerUUID
				name: type: 'string', faker: 'name.findName'
			required: ['_id', 'name']
		script:
			type: 'object'
			properties:
				script-name: type: 'string', faker: 'system.fileName'
				script-url: mapping.faker-url
			required: ['scriptName', 'scriptUrl']
		time-to-execute: mapping.custom-integer
		steps: ['unknow nows']
		success-rate: mapping.custom-integer
		be-used-count: mapping.custom-integer
	required: ['_id', 'companyId', 'name', 'type', 'doc', 'docCreatedTime', 'docCreator', 'manualOperationCount',
		'status', 'scriptCreatedTime', 'scriptCreator', 'script', 'timeToExecute', 'steps', 'successRate', 'beUsedCount'
	]


test-plans = [(jsf schema) for i in [1 to amount]]

fs.write-file-sync __dirname + '/../src/app/data/test-plans.json', JSON.stringify {test-plans}



