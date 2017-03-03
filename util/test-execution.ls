module.exports = class Test-execution extends require './abstract-data-entry'
  @id = 1
  @release-date = new Date
  ->
    super ...
    @start-time = 1 * @@@get-random-datetime-between start = -100 * Math.random!, end = start + Math.random!
    # console.log "start-time: ", @start-time
    @end-time = 1 * @@@get-random-datetime-between @start-time, @start-time + Math.random! * 3 * A_HOUR = 60m * 60s * 1000ms
    # console.log "end-time: ", @end-time
    if Math.random! > success-rate = 0.8
      @result = 'FAIL'
      @reason = '双速电机调速失败'
    else
      @result = 'PASS'
    @ea-box = 
      _id : id = if Math.random! > 0.2 then 1 else  ~~(9 * Math.random!) + 2
      name: "测试盒 #id"
    @test-plan =
      _id : id = if Math.random! > 0.2 then 1 else 2
      name: if id is 1 then 'b36自动洗测试' else 't121双速洗测试'
    @tester = 
      _id : id = if Math.random! > 0.2 then 1 else 2
      name: if id is 1 then '张珊' else '李斯'

    @steps = 3 + ~~(Math.random! * 30)

    
