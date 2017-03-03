Ea-box = require './ea-box'
Test-execution = require './test-execution'
test-plan-parser = require './test-plan-parser'

fs = require 'fs'

boxes = [new Ea-box "测试盒 #name", 'in-service' for name in [1 to 10]]
# console.log "boxes: ", JSON.stringify boxes

test-boxes = 
  boxes: boxes
  waveform:
    title: 'Average CPU Usage (Live)'
    chart:
      * key: "Average CPU Usage"
        values:
          * x: 5, y: 72
          * x: 10, y: 26
          * x: 15, y: 51
          * x: 20, y: 36
          * x: 25, y: 66
          * x: 30, y: 69
          * x: 35, y: 50
          * x: 40, y: 35
          * x: 45, y: 49
          * x: 50, y: 64
          * x: 55, y: 37
          * x: 60, y: 78
          * x: 65, y: 54
          * x: 70, y: 8
          * x: 75, y: 52
          * x: 80, y: 50
          * x: 85, y: 56
          * x: 90, y: 71
          * x: 95, y: 31
          * x: 100, y: 37
          * x: 105, y: 15
          * x: 110, y: 45
          * x: 115, y: 35
          * x: 120, y: 28
          * x: 125, y: 7
          * x: 130, y: 36
          * x: 135, y: 7
          * x: 140, y: 79
          * x: 145, y: 12
          * x: 150, y: 5
      ...

fs.write-file-sync __dirname + '/../src/app/data/test/boxes.json', JSON.stringify test-boxes



executions = [new Test-execution for i in [1 to 200]]

fs.write-file-sync __dirname + '/../src/app/data/test/executions.json', JSON.stringify {executions}


test-info = test-plan-parser.get-test-info  {
  test-package: 'midea-kitchen-tests'
  package-name: 'midea-kitchen-tests/bin'
  test-name: 'b36/分步测试/分步测试'
}, (test-info)->
  fs.write-file-sync __dirname + '/../src/app/data/test/test-info.json', JSON.stringify {test-info}
