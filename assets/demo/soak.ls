Promise = require 'bluebird'

引脚 = (require './分步测试/引脚定义').get-name-pin-map!
{操作, 期望} = require '../美的洗碗机操作与期望'
{分水阀, 温度传感器, 流量计, 双速泵} = require '../美的洗碗机器件'
framework = require './framework'

module.exports = framework ->
  steps:
    * 操作.排水          时限: 45s
    * 操作.进水          容量: 4L
    * 操作.频率检测       圈数: 1.3
    * 操作.高速洗涤       时限: 300s , 期望: 期望.分水阀位置('上下')
    * 操作.排水          时限: 45s  , 期望: 期望.分水阀位置 '不变'
    ...