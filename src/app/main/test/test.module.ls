

'use strict'

get-mock-fn = (name)-> -> console.log "socket #name : ", &

create-fake-socket = ->
  fake-socket =
    observers: {}
    on: (event-name, observer)->
      @observers[event-name] ||= []
      @observers[event-name].push observer

    once: (event-name, observer)->
      called = false
      @on event-name, -> if !called then observer ...

    trigger: (event-name, data)-> for observer in @observers[event-name]
      observer data
  [fake-socket[name] = get-mock-fn name  for name in <[ join leave emit ]>]
  fake-socket


# ngFileUpload is for uplaod third-part file upload library
angular.module 'app.test', ['btford.socket-io', 'angularMoment', 'ngFileUpload', 'ngFileSaver']

.factory 'socketManager', (socket-factory) ->

  client-socket: null

  rooms: []

  information : {}

  init-socket: (server-url) ->
    if @client-socket is null
      # console.log 'aaaaa'
      @client-socket = socket-factory {
        prefix    : ''
        io-socket : io.connect(server-url)
      }
      @client-socket.on 'has-connect', (data) !->
        console.log data
    @client-socket

  # init-connection: (server-url) ->
  #   @init-socket server-url
  #   @join-rooms room-array
  #   @client-socket

  join-rooms: (room-array) !->
    @rooms = room-array
    @client-socket.emit('join-room', room-array)

  leave-rooms: !->
    @client-socket.emit('leave-room', {rooms: @rooms})

  start-test: (config) !->
    @client-socket.emit('start-test', config)

  record-info: (box-id, socket-event, data) ->
    @information[box-id] = @information[box-id] || {}
    @information[box-id][socket-event] = data

  remove-listeners: ->
    events = ['test-started', 'step-status', 'test-success', 'test-fail']
    [@client-socket.remove-all-listeners socket-event for socket-event in events]

.filter 'dateTimeShort', ->
  (datetime-number)->
    moment.locale 'zh-cn'
    (moment new Date datetime-number).from-now!

.filter 'calendar', ->
  (datetime-number)->
    moment.locale 'zh-cn'
    (moment new Date datetime-number).calendar!

.filter 'dateTimeFull', ->
  (datetime-number)->
    moment.locale 'zh-cn'
    (moment new Date datetime-number).format 'LLL'

.filter 'dateTimeNearShortFarFull', ->
  (datetime-number)->
    moment.locale 'zh-cn'
    if is-within-an-hour = Date.now! - datetime-number < 60m * 60s * 1000
      (moment new Date datetime-number).from-now!
    else
      (moment new Date datetime-number).format 'LLL'

.filter 'duration', ->
  (duration-number)->
    # moment.duration duration-number .humanize!
    d = moment.duration duration-number
    y = d.years! ; M = d.months! ; D = d.days! ; h = d.hours! ; m = d.minutes! ; s = d.seconds!
    result = ''
    result += y + '年' if y
    result += M + '月' if M
    result += D + '日' if D
    result += h + '小时' if h
    result += m + '分' if m
    result += s + '秒' if s
    result

.filter 'limitNameLength', ->
  (name) ->
    if name
      if name.length > 10
        name = name.slice 0, 10
        name += '...'
    name

# .factory 'testsService', (api-resolver, $root-scope, $interval)->
#   raw = {}
#   cache = {}
#   tests-service =
#     prepare-data: ->
#       if !cache.boxes
#         api-resolver.resolve('testBoxes@get')
#         .then (data)->
#           raw.boxes = data
#           console.log data
#           api-resolver.resolve('testExecutions@get')
#         .then (data)->
#           cache.executions = raw.executions = data.executions
#           console.log data
#       else
#         Promise.resolve!

#     get-boxes: ->
#       if !raw.boxes
#         @prepare-data!
#         .then ~>
#           cache.boxes = @create-boxes! if !cache.boxes
#           cache.waveform = raw.boxes.waveform if !cache.waveform
#           cache{boxes, waveform}
#       else
#         Promise.resolve cache{boxes, waveform}

#     create-boxes: -> [@create-box box for box in raw.boxes.boxes]

#     create-box: (box)->
#       box.executions = raw.executions?filter -> it.box._id is box._id
#       console.log box.executions
#       last-execution = (box.executions.sort (a, b)-> a.end-time > b.end-time).0
#       current-execution = @get-fake-current-exectuion!

#       r = Math.random!
#       switch
#       | r < 0.3         =>  box.last-execution = last-execution
#       | 0.3 < r < 0.8   =>  box.last-execution = last-execution  ;  box.current-execution = current-execution
#       | otherwise       =>  # brand-new
#       box

#     get-fake-current-exectuion: ->
#       test-plan : 't121双速洗测试'
#       tester : '赵武'
#       total-steps : 16
#       completed-steps : 3
#       start-time : "3:12'"
#       estimate-end-time : "5:31'"
#       step-estimate-end-time: "12'25''"

#     get-box: (id)->
#       if !cache.boxes
#         @get-boxes!
#         .then ~> @_get-box id
#       else
#         Promise.resolve @_get-box id

#     _get-box: (id)-> (cache.boxes?filter -> it._id.to-string! is id.to-string!)?0

#     get-executions-by-box: (box-id)->
#       @get-box box-id
#       .then (box)-> box.executions

#     create-execution: do ->
#       box = null
#       (bid, pid)->
#         Promise.resolve!
#         .then ~> if !bid? then Promise.resolve! else @get-box bid
#         .then (_box)~>
#           box := _box
#           if !pid? then Promise.resolve! else @get-plan pid
#         .then (plan)~>
#           Promise.resolve @_create-execution box, plan

#     _create-execution: (box, plan)->
#       cache.executions
#       execution =
#         _id: @_get-max-execution-id! + 1
#         box: box
#         tester: _id: $root-scope.current-user?_id, name: $root-scope.current-user?fullname
#         plan: plan or _plan =
#           _id: 1
#           test-package: 'midea-kitchen-tests'
#           package-name: 'midea-kitchen-tests/bin'
#           test-name: 'b36/分步测试/分步测试'

#         initial: !->
#           @add-steps-info!
#           .then ~>
#             [step.status = 'pending' for step in @steps]
#             @start-time = current = Date.now!
#             @start-step step-id: 1, step-start-time: current
#             @mock-socket-message-step-started-auto.apply @

#         time-update-interval: 1 * 1000ms

#         start-step: ({step-id, step-start-time})->
#           @estimate-end-time = @calculate-estimate-test-end-time!
#           @set-current-step {step-id, step-start-time}
#           @update-end-times!

#         update-end-times: ->
#           console.log "update-end-times of step: ", @current-step.name
#           clear-timeout @current-step.estimate-end-time-timer if @current-step.estimate-end-time-timer
#           @current-step.estimate-end-time-timer = set-interval ~>
#             @estimate-end-time -= @time-update-interval
#             @current-step.estimate-end-time -= @time-update-interval
#             @scope?$apply! # 在create-execution页面时，没有scope
#           , @time-update-interval

#         end-current-step: !->
#           clear-timeout @current-step.estimate-end-time-timer
#           @current-step.status = 'ended'
#           @current-step.end-time = Date.now! # TODO: 监听socket的step-end消息，来更新
#           @completed-steps-count++

#         calculate-estimate-test-end-time: -> # TODO：需要进一步细化，考虑并行任务
#           pending-steps = @steps.filter (-> it.status is 'pending')
#           console.log "pending-steps: ", pending-steps.length
#           pending-steps.reduce ((amount, step)-> amount + step.estimate-execution-time), 0

#         add-steps-info: ->
#           api-resolver.resolve('testInfo@get')
#           .then ({test-info})~>
#             @total-steps-count = test-info.steps.length # TODO: 需要计算branch
#             @completed-steps-count = 0
#             @plan.estimate-execution-time = test-info.estimate-execution-time
#             @steps = test-info.steps

#         set-current-step: ({step-id, step-start-time})->
#           @current-step = @steps.filter (-> it.id.to-string! is step-id.to-string!) .0
#           @current-step.status = 'active'
#           @current-step.start-time = step-start-time
#           @current-step.estimate-end-time = @current-step.estimate-execution-time

#         start-execution: (start, end)->
#           disconnect = tests-service.connect-test-box @box._id, action = ~>
#             socket.once 'test-started', ({start-time})-> execution.initial! ; disconnect! ; end!
#             socket.emit 'start-test', @plan
#             start!
#           cache.executions.push  execution
#           execution

#         watch: (scope)->
#           @scope = scope
#           disconnect = tests-service.connect-test-box @box._id, action = ~>
#             scope.$on '$stateChangeStart', (event, to-state)~>
#               # 离开页面，断开test-box
#               console.log "is going to '#{to-state}' with event: ", event
#               disconnect!
#             socket.on 'step-started', ({id, name, time})~>
#               # 监听测试步骤变化
#               console.log("time", time)
#               @end-current-step!
#               @start-step step-id: id, step-start-time: time
#             socket.on 'step-complete', ({id, time})->
#               socket.trigger 'step-started', time: time, id : id
#               # 正式使用的代码
#               # scope.$apply!

#               # TODO：驱动开发时，点击发起的变化，不需要apply
#               scope.$apply! if not $root-scope.$$phase in ['$apply', '$digest']


#         mock-socket-message-step-started-auto: !->
#           auto_id = 0
#           time = 0
#           that = @
#           length = @.steps.length
#           console.log length
#           random-delay = ->
#             console.log("enter")
#             console.log time
#             execution-time = @steps[auto_id].estimate-execution-time
#             if Math.random! > 0.5
#               execution-time * (Math.random! * 0.1 + 1)
#             else
#               execution-time * (1 - Math.random! * 0.1)
#           step-started-auto = !->
#             socket.trigger 'step-complete', time: Date.now!, id: auto_id + 2
#             auto_id++
#             console.log that
#             time := random-delay.apply that
#             time /= 1000
#             time := parse-int time
#             time *= 1000
#             console.log time
#             if auto_id < length - 1
#               $interval step-started-auto, time, 1
#           $interval step-started-auto, 1000, 1
#           # set-interval ~>
#           #   socket.trigger 'step-complete'
#           #   auto_id++
#           #   time = random-delay!
#           # , time
#           # set-interval step-started-auto!, random-delay!
#           #$interval step-started-auto, random-delay!, @steps.length

#         # TODO：驱动开发用方法
#         mock-socket-message-test-started: ->
#           socket.trigger 'test-started', start-time: Date.now!

#         mock-socket-message-step-started: do ->
#           id = 2
#           ->
#             socket.trigger 'step-started', time: Date.now!, id: id++


#     get-execution-by-id: (id)->
#       @prepare-data!.then ->
#         (cache.executions?filter -> it._id.to-string! is id.to-string!)?0

#     _get-max-execution-id: -> Math.max.apply null, cache.executions.map (._id)

#     # 测试计划详情页面使用，获取所有测试执行的假数据
#     getAllExecutions: ->
#       api-resolver.resolve('testExecutions@get')
#       .then (data)->
#         data


#     connect-test-box: (box-id, action)->
#       socket.join box-id # 加入box-id的room
#       action!
#       end-session = -> socket.leave box-id

# # get the test-plans and format them
# .factory 'testPlanService', (api-resolver, $root-scope)->
#   test-plan-service =
#     company-id: $root-scope.current-user?company-id
#     get-plans: ->
#       api-resolver.resolve('testPlan.list@get')
#       .then (data)->
#         data

# .factory 'controlTestSocketService', (socket-actory)-> socket-actory!


