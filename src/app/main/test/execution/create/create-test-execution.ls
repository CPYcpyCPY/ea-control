angular.module 'app.test'

.config ($state-provider) !->
  'ngInject'
  $state-provider.state 'app.test.new-execution', {
    url: '/new-exec?boxId?planId'
    resolve:
      plans: (api-resolver, $state-params) ->
        api-resolver.resolve 'retrievePlans@get'

      boxes: (api-resolver, $state-params) ->
        api-resolver.resolve 'retrieveBoxes@get'

      current-plan: (api-resolver, $state-params) ->
        result = {}
        if $state-params.plan-id
          result = api-resolver.resolve 'retrieveOnePlan@get', {'planId': $state-params.plan-id}
        result

      current-box: (api-resolver, $state-params) ->
        result = {}
        if $state-params.box-id
          console.log 'this time has boxId: ', $state-params.box-id
          result = api-resolver.resolve 'retrieveOneBox@get', {'boxId': $state-params.box-id}
        result

    views:
      'content@app':
        template-url: 'app/main/test/execution/create/create-test-execution.html'
        controller-as: 'vm'
        controller: (plans, boxes, current-plan, current-box, $state, $scope, $state-params, $md-dialog, $md-media, $root-scope) !->

          # console.log 'plans: ', plans.data
          # console.log 'boxes: ', boxes.data
          # console.log 'current-plan: ', current-plan
          # console.log 'current-box: ', current-box

          @boxes = boxes.data
          # @boxes = [1,2,3,4,5]
          @plans = plans.data
          @current-plan = current-plan.data
          @current-box = current-box.data
          # debugger
          @execution = init-new-execution!

          @show-guide-picture = !~>
            chosen-plan = find-plan-by-id(@execution.test-plan._id, @plans)[0]
            chosen-box = find-box-by-id(@execution.ea-box._id, @boxes)[0]
            @execution.script = chosen-plan.script

            # @execution.script =
            #   test-package  : 'driven-test-plans'
            #   package-name  : '../node_modules/midea-kitchen-tests/bin/b36'
            #   test-name     : 'soak'
            @execution.ea-box._id = chosen-box._id
            @execution.ea-box.name = chosen-box.name
            # @execution.script = chosen-plan.script

            @execution.test-plan.name = chosen-plan.name
            # @execution.ea-box.name = chosen-box.name
            # debugger
            $md-dialog.show {
              click-outside-to-close: true,
              locals: {execution: @execution},
              controller: guide-controller,
              template-url: 'app/main/test/execution/create/guide-picture.html'
            }

          @return-to-boxes-list = !->
            $state.go 'app.test.boxes'

          ~function init-new-execution
            execution =
              name: null
              execution-creator:
                _id: $root-scope.current-user._id
                username: $root-scope.current-user.username
              startTime: null
              endTime: null
              result: null
              comment: null
              stepExecuteDetail: []
              script: {}

            if @current-plan
              execution.test-plan = { _id: @current-plan._id, name: @current-plan.name }
            else
              execution.test-plan = null

            if @current-box
              execution.ea-box = { _id: @current-box._id, name: @current-box.name }
            else
              execution.ea-box = null

            execution

  }

  function find-plan-by-id id, plans then
    for plan in plans
      if plan._id is id
        # debugger
        plan

  function find-box-by-id id, boxes then
    for box in boxes
      if box._id is id
        console.log 'chosen box: ', box
        box

  !function guide-controller socket-manager, $scope, $md-dialog, $state, execution, $root-scope then

    @execution = execution
    @md-dialog = $md-dialog
    $scope.execute-button = "确认已接好线路"

    $scope.cancel = !->
      $md-dialog.cancel!

    $scope.start-execution = !~>
      console.log 'wait-to-start'
      $scope.execute-button = "等待测试盒执行..."

      handle-socket!

    ~function handle-socket
      @socket = socket-manager.init-socket 'http://localhost:3000'
      socket-manager.remove-listeners!
      socket-manager.leave-rooms!
      socket-manager.join-rooms [@execution.ea-box._id]
      @socket.emit 'start-test', @execution
      console.log 'start-test-info: ', @execution
      @socket.on 'test-started', $scope.end

    $scope.end = (data) !~>
      console.log 'test-started: ', data
      $scope.execute-button = "执行开始"
      $md-dialog.cancel!
      $state.go 'app.test.exec-detail', {execution-id: data.execution._id, plan-id: @execution.test-plan._id}
