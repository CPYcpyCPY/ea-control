
angular.module 'app.test'
.config ($state-provider)!->
  'ngInject'
  $state-provider.state 'app.test.exec-detail', {

    url: '/executions/:executionId?planId'
    resolve:
      execution: (api-resolver, $state-params) ->
        api-resolver.resolve 'retrieveOneExecution@get', { 'executionId': $state-params.execution-id }
      plan: (api-resolver, $state-params) ->
        api-resolver.resolve 'retrieveOnePlan@get', { 'planId': $state-params.plan-id }
    views:
      'content@app':
        template-url: 'app/main/test/execution/detail/test-execution-detail.html'
        controller-as: 'vm'
        controller: (socket-manager, plan, execution, $scope, $state, $root-scope, $md-toast, $interval, $window)!->
          # 用于倒计时管理
          timer-map = {}

          @test-progress = 25
          @test-true = true
          @input-pins = [{name: '温度',pin:'AO1',data: 45}, {name: '浊度',pin:'AO2',data: 200}, {name: '流量',pin:'DPO1',data: '上'}]
          @output-pins = [{name:'排水阀',pin:'DI1',data: '开'}, {name:'进水阀',pin:'DI2',data: '开'}, {name: '高速汞',pin:'DI3',data: '关'}, {name: '低速汞',pin:'DI4',data:'关'}, {name: '加热管',pin:'DI5',data: '开'}]

          @execution = execution.data
          @step-detail = get-step-detail plan.data, execution.data
          @execution.estimate-end-time = get-estimate-end-time @step-detail

          @return-to-box-detail = !->
            $state.go "app.test.box-detail", { box-id: @execution.ea-box._id }

          @download-script = !->
            $window.open '/api/demoDownload/doc'

          handle-socket!

          console.log 'current-user: ', $root-scope.current-user
          console.log 'plan: ', @plan
          console.log 'step-detail: ', @step-detail
          console.log 'execution: ', @execution

          $scope.options = {
            chart: {
              type: "lineWithFocusChart",
              height: 450,
              margin: {
                top: 20,
                right: 20,
                bottom: 60,
                left: 40
              },
              duration: 500,
              useInteractiveGuideline: true,
              xAxis: {
                axisLabel: '日期',
                tickFormat: (d) -> d3.time.format('%x')(new Date(d))
              }
              x: (d) -> d.x,
              y: (d) -> d.y,
              x2Axis: {
                axisLabel: '日期',
                tickFormat: (d) -> d3.time.format('%x')(new Date(d))
              }
            }
          }


          $scope.data = generate-data!

          function generate-data
            line1 = []
            line2 = []
            line3 = []
            now =+ new Date!
            for i from 0 to 99
              currentX = now + i * 1000 * 60 * 60 * 24
              currentY1 = parseInt Math.random! * 60 + 30, 10
              currentY2 = parseInt Math.random! * 40 + 20, 10
              currentY3 = parseInt Math.random! * 4, 10
              line1.push {x: currentX, y: currentY1}
              line2.push {x: currentX, y: currentY2}
              line3.push {x: currentX, y: currentY3}
            [
              {
                values: line1,
                key: "温度('C)",
                color: '#ff7f0e'
              },
              {
                values: line2,
                key: '风机(rev/s)',
                color: '#2ca02c'
              },
              {
                values: line3,
                key: '分水阀(L)',
                color: '#7777ff',
                area: true
              }
            ]

          ~function get-step-detail plan, execution
            step-detail = plan.steps

            step-detail.map (step)-> step.status = 'pending'

            execution.step-execute-detail.for-each (step, i)!->
              step-detail[i].result = step.result
              step-detail[i].time-used = step.time-used
              step-detail[i].status = step.status

            step-detail

          console.log 'step-detail: ', @step-detail

          ~function get-estimate-end-time step-detail
            step-detail.reduce (sum, step)->
              if step.status is 'pending' then sum + step.expected-step-duration
              else sum
            , 0


          ~function handle-socket
            socket = socket-manager.init-socket 'http://localhost:3000'
            socket-manager.join-rooms @execution.ea-box._id

            socket.on 'step-status', watch-step-status
            socket.on 'test-success', watch-test-success
            socket.on 'test-fail', watch-test-fail


          ~function count-down data
            timer-map[data.name] := $interval !~>
              console.log 'remainingTime', @step-detail[data.id - 1].remainingTime

              if @step-detail[data.id - 1].remainingTime <= 0
                $interval.cancel timer-map[data.name]
                delete timer-map[data.name]
              else @step-detail[data.id - 1].remainingTime = @step-detail[data.id - 1].remainingTime - 1000
            , 1000


          ~function cancel-timer data
            $interval.cancel timer-map[data.name]
            delete timer-map[data.name]


          ~function get-remaining-time data
            if @step-detail[data.id - 1].name is '进水' then 110 * 1000
            else @step-detail[data.id - 1].expected-step-duration


          ~function watch-step-status data
            console.log 'step-status: ', data

            # 忽略掉启动项的信号
            if data.id is 1 then return
            else data.id = data.id - 1

            @step-detail[data.id - 1].status = data.status

            switch data.status
            case 'active'
              @step-detail[data.id - 1].remainingTime = get-remaining-time data
              count-down data
            case 'fail'
              @execution.reason = data.err
            case 'ended'
              @step-detail[data.id - 1].time-used = data.time-used
              if timer-map[data.name] then cancel-timer data


          ~function watch-test-success data
            console.log 'test-success: ', data
            @execution.result = 'pass'
            @execution.end-time = data.time
            console.log 'step-detail:', @step-detail
            $mdToast.show(
              $mdToast.simple()
                .textContent('测试成功完成！')
                .position('top right')
                .hideDelay(3000)
            )


          ~function watch-test-fail data
            console.log 'test-fail: ', data
            @execution.result = 'fail'
            @execution.end-time = data.time
            @execution.result = 'fail'
            console.log 'execution: ', @execution
            $mdToast.show(
              $mdToast.simple()
                .textContent('测试失败')
                .position('top right')
                .hideDelay(3000)
            )

  }
