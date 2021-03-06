# 这是美的洗涤电器目前最复杂的测试之一，我们用它来验证ast DSL的正确性与完备性
# 原始测试计划文本参见：http://hcp.sysu.edu.cn/download/attachments/14746348/%E6%B4%97%E6%B6%A4%E6%97%B6%E5%BA%8F.xls?version=1&modificationDate=1453808987755&api=v2

{操作, 期望} = require '../美的洗碗机操作与期望'
{分水阀, 温度传感器, 流量计} = require '../美的洗碗机器件'

分水阀每度耗时 = 5ms
module.exports = 
  plan:
    name: '洗碗机自动洗功能测试'
    description-url: 'http://hcp.sysu.edu.cn/download/attachments/14746348/%E6%B4%97%E6%B6%A4%E6%97%B6%E5%BA%8F.xls?version=1&modificationDate=1453808987755&api=v2'
    pins:
      # ------ 控制 ---------- 
      DI1  :   '排水阀'   
      DI2  :   '进水阀'   
      DI3  :   '双速洗涤泵高速'   
      DI4  :   '双速洗涤泵低速'   
      DI5  :   name: '分水阀', extend: 分水阀
      DI7  :   '加热管'  
      DI8  :   '分配器'  
      DI9  :   '再生阀'  
      # ------ 检测 ---------- 
      AO1  :   '浊度传感器'  
      AO2  :   name: '温度传感器', extend: 温度传感器
      DPO1 :   name: '流量计', extend: 流量计
      DPO2 :   name: '分水阀零位置计数器' , frequency: 1000 / (分水阀每度耗时 * 360), duty: 1

    time-tolerance: 1000ms

    steps: 
      # ------------------------------ 预洗 ------------------------------
      * 操作.启动         
      * 操作.排水          时间: 45s  
      * 操作.进水          容量: 4L   
      * 操作.频率检测      
      * 操作.洗涤加热       温度: 50T  , 期望: [期望.分水阀位置 '上下', 期望.双速泵 {高速: 5m, 低速: 5m}] # 如何输出为可引用全局变量
      * 操作.洗涤          时间: 600s  , 期望: 期望.分水阀位置 '上下' 
      * 操作.洗涤          时间: 300s  , 期望: 期望.分水阀位置 '上下' # TODO：多个同操作是否可以合并？
      * 操作.排水          时间: 3s  
      * 操作.洗涤          时间: 300s  , 期望: 期望.分水阀位置 '上下' 
      * 操作.排水          时间: 45s  
      * 操作.进水          容量: 3.8L   

      # ------------------------------ 主洗 ------------------------------
      * 操作.洗涤分配加热   时间: 90s  , 期望: 期望.分水阀位置 '上下' 
      * 操作.洗涤加热       温度: 50T  , 期望: 期望.分水阀位置 '上下' 
      * 操作.洗涤          时间: 600s  , 期望: 期望.分水阀位置 '上下' 
      * 操作.洗涤加热       温度: 62T  , 期望: 期望.分水阀位置 '上下' 
      * 操作.洗涤          时间: 2400s  , 期望: 期望.分水阀位置 '上下' 

      # ------------------------------ 漂洗 ------------------------------
      * 操作.排水          时间: 3s  
      * 操作.洗涤          时间: 10s  , 期望: 期望.分水阀位置 '上下' 
      * 操作.排水          时间: 3s  
      * 操作.洗涤          时间: 3s  , 期望: 期望.分水阀位置 '上下' 
      * 操作.排水          时间: 45s  
      * 操作.进水          容量: 4.2L   
      * 操作.洗涤          时间: 600s  , 期望: 期望.分水阀位置 {上: 2.5m, 下: 2.5m} 
      * 操作.排水          时间: 45s  
      * 操作.进水          容量: 3.2L   
      * 操作.洗涤          时间: 300s  , 期望: 期望.分水阀位置 {上: 2.5m, 下: 2.5m} 
      * 操作.排水          时间: 3s  
      * 操作.洗涤          时间: 5s  , 期望.分水阀位置 '不变' 
      * 操作.排水          时间: 45s  
      * 操作.进水          容量: 3.4L   
      * 操作.洗涤加热       温度: 45T  , 期望: 期望.分水阀位置 '上下' 
      * 操作.洗涤分配加热   时间: 60s  , 期望: 期望.分水阀位置 '上' 
      * 操作.洗涤加热       温度: 55T  , 期望: 期望.分水阀位置 {上: 2.5m, 下: 2.5m} 
      * 操作.洗涤分配加热   时间: 20s  
      * 操作.洗涤加热       时间: 10s  
      * 操作.洗涤分配加热   时间: 20s  
      * 操作.洗涤加热       时间: 10s  
      * 操作.洗涤分配加热   时间: 60s  , 期望: 期望.分水阀位置 '下'
      * 操作.洗涤加热       温度: 66T  , 期望: 期望.分水阀位置 {上: 2.5m, 下: 2.5m}  
      * 操作.洗涤          时间: 20s  
      * 操作.排水          时间: 3s  
      # ------------------------------ 干燥 ------------------------------
      * 操作.静止          时间: 600s  
      * 操作.排水          时间: 45s  
      * 操作.再生进水       容量: 0.2L   
      * 操作.排水          时间: 10s  
      * 操作.再生          容量: 120   
      * 操作.静止          时间: 300s  
      * 操作.静止          时间: 600s  # TODO：连续两步静止，合并？
      * 操作.进水          容量: 1L   
      * 操作.排水          时间: 10s  
      * 操作.进水          容量: 1L   
      * 操作.排水          时间: 15s  
      * 操作.排水          时间: 45s  

      
  driven-fn: (mock-socket)-> mock-socket.emit 'start-test'
