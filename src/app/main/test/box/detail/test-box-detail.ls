angular.module 'app.test'

.config ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider)!->
  'ngInject'
  $state-provider.state 'app.test.box-detail', {
    url: '/boxes/:boxId'
    resolve:
      box: (api-resolver, $state-params) ->
        console.log 'get test box detail'
        api-resolver.resolve 'retrieveOneBox@get', {'boxId': $state-params.box-id}

    views:
      'content@app':
        template-url: 'app/main/test/box/detail/test-box-detail.html'
        controller-as: 'vm'
        controller: (box, $scope, $state, $interval, $mdDialog, $mdMedia, $root-scope, socket-manager, $state-params)!->
          @dt-options =
            dom       : '<"top"f>rt<"bottom"<"left"<"length"l>><"right"<"info"i><"pagination"p>>>'
            pagingType: 'simple'
            autoWidth : false
            responsive: true

          @box = box.data

          @box.executions = @box.executions.sort (a, b)-> (new Date a.startTime).get-time! - (new Date b.startTime).get-time!

          @box.executions = @box.executions.map (execution)->
            if execution.result is '' then execution.result = 'running'
            execution

          console.log @box.executions

          @box.current-execution = @box.executions[@box.executions.length - 1]


          $scope.look-exec-detail = (box, execution-id, plan-id) !->
            $state.go "app.test.exec-detail", {execution-id: execution-id, plan-id: plan-id}

          @return-to-box-list = ->
            $state.go 'app.test.boxes'

          # ===================== socket event define ========================

          @socket = socket-manager.init-socket 'http://localhost:3000'
          socket-manager.join-rooms $state-params.box-id
          @socket.on 'test-success', (data) !~>
            @box.current-execution.end-time = data.time
            @box.current-execution.result = data.result
          @socket.on 'test-fail', (data) !~>
            @box.current-execution.end-time = data.time
            @box.current-execution.result = data.result

  }

