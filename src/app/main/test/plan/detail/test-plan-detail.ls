'use strict'

angular.module 'app.test'

.config ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider) !->
  'ngInject'

  $state-provider.state 'app.test.plan-detail', {

    url: '/plans/:planId'
    resolve:
      plan: (api-resolver, $state-params) ->
        api-resolver.resolve 'retrieveOnePlan@get', {'planId': $state-params.plan-id}
    views:
      'content@app':
        template-url: 'app/main/test/plan/detail/test-plan-detail.html'
        controller-as: 'vm'
        controller: (socket-manager, plan, $state, $scope, $root-scope, api, $md-toast) !->
          # data-table参数
          @dt-options =
            dom         : '<"top"f>rt<"bottom"<"left"<"length"l>><"right"<"info"i><"pagination"p>>>'
            paging-type : 'simple'
            auto-width  : false
            responsive  : true

          @current-user = $root-scope.current-user

          @plan = plan.data
          pass-count = (@plan.executions.filter (execution)-> execution.result is 'pass') .length
          fail-count = (@plan.executions.filter (execution)-> execution.result is 'fail') .length
          @plan.success-rate = (pass-count / (pass-count + fail-count) * 100).to-fixed 2

          if @plan.success-rate is 'NaN' then @plan.success-rate = 0

          if @plan.executions.length is 0 then @plan.time-to-execute = '0 分钟' else @plan.time-to-execute = (@plan.executions.length * 8) + ' 分钟'

          @plan.executions = @plan.executions.map (execution)->
            unless execution.result then execution.result = 'running'
            execution

          #下载按钮逻辑
          @download-plan-doc = (ev) !~>
            console.log 'ready to download'
            window.open '/api/demoDownload/E4 时序表.doc'

          #上传按钮逻辑
          @upload-plan-script = (file, err-files)!~>
              console.log 'file: ', file
              api.demo-upload {id: @plan._id, user-id: $root-scope.current-user._id, username: $root-scope.current-user.username} .then (res) !~>
                if res.status.to-lower-case! is 'ok'
                  @plan.status = 'executable'
                  $mdToast.show(
                    $mdToast.simple()
                      .textContent('上传脚本成功！')
                      .position('top right')
                      .hideDelay(3000)
                  );


          # click the exe plan button
          @go-to-create-execution = (plan-id)->
            $state.go "app.test.new-execution", { plan-id: plan-id }

          @return-to-plan-list = !->
            # socket-manager.remove-listeners!
            # socket-manager.leave-rooms null
            $state.go "app.test.plans"

          @go-to-detail = (execution-id)->
            $state.go "app.test.exec-detail", { execution-id, plan-id: @plan._id}
  }
