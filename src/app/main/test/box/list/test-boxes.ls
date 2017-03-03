'use strict'

angular.module 'app.test'
.config ($state-provider)!->
  'ngInject'
  $state-provider.state 'app.test.boxes', {

    url: '/boxes'
    resolve:
      boxes: (api-resolver) ->
        api-resolver.resolve 'retrieveBoxes@get'

    views:
      'content@app':
        template-url: 'app/main/test/box/list/test-boxes.html'
        controller-as: 'vm'
        controller: (socket-manager, api-resolver, boxes, $scope, $interval, $state, $root-scope) !->

          @boxes = boxes.data

          set-box-execution-estimate-end-time @boxes
          set-box-current-step @boxes

          # console.log '测试盒列表的boxes: ', boxes.data

          @go-to-box-detail = (box-id) !->
            socket-manager.leave-rooms box-id
            $state.go 'app.test.box-detail', {box-id: box-id}

          @go-to-new-execution = (box-id) !->
            socket-manager.leave-rooms box-id
            $state.go 'app.test.new-execution', {box-id: box-id}

          handle-socket!

          function set-box-execution-estimate-end-time boxes
            boxes.map (box)->
              if box.execution and not box.execution.result then box.execution.estimateEndTime = (Math.floor(Math.random() * 30) + 1) + '分钟'
              box

          function set-box-current-step boxes
            for box in boxes
              box.current-step = {}
              if box.execution
                box.current-step = box.execution.step-execute-detail[box.execution.step-execute-detail.length - 1]

          function find-box-by-id id, boxes then
            for box in boxes
              if box._id is id
                box

          # =================== socket =========================

          ~function handle-socket

            # 获取盒子id列表
            @room-array = []
            for box in @boxes
              @room-array.push box._id

            socket = socket-manager.init-socket 'http://localhost:3000'
            socket-manager.join-rooms @room-array
            socket-manager.remove-listeners!

            socket.on 'test-started', retrieve-box-execution
            socket.on 'step-status', watch-step-status
            socket.on 'test-success', wathc-test-success
            socket.on 'test-fail', watch-test-fail

          ~function retrieve-box-execution data
            for box in @boxes
              if box._id is data.box-id
                box.execution = api-resolver.resolve 'retireveOneExecution@get', {execution-id: data.execution-id}

          ~function watch-step-status data
            if data.status is 'pending'
              console.log 'step-status: ', step.status

            if data.status is 'active'
              console.log 'step-status: ', step.status
              new-step =
                _id: data._id
                name: step.name
                step-duration: null
                result: null
              find-box-by-id(data._id, @boxes)[0].current-step = new-step

            if step.status is 'ended'
              console.log 'step-status: ', step.status
              @box.current-step.step-duration = data.time-used

            if step.status is 'pass' or step.status is 'fail'
              console.log 'step-status: ', step.status
              @box.current-step.result = step.status

          ~function wathc-test-success data
            box = find-box-by-id(data._id, @boxes)[0]
            box.execution.end-time = data.time
            box.execution.result = data.result

          ~function watch-test-fail data
            box = find-box-by-id(data._id, @boxes)[0]
            box.execution.end-time = data.time
            box.execution.result = data.result

          # =================== socket =========================
  }
