'use strict'
angular.module 'app.test'

.config ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider) !->
  'ngInject'
  $state-provider.state 'app.test.create-plan', {
    url: '/plan/create'
    views:
      'content@app':
        template-url: 'app/main/test/plan/create/test-plan-create.html'
        controller-as: 'vm'
        controller: ($scope, $interval, $root-scope, $state, $timeout, api, $md-toast)!->
          # $root-scope.current-user =
          #   username: 'zhaowu'
          #   _id: 1
          #   role: 'admin'

          @test-plan =
            doc-create-date: new Date!
            doc-creator:
              username: $root-scope.current-user.username
              _id: $root-scope.current-user._id
            type: null
            manual-operation-frequency: null
            name: null
            status: null
            expected-execute-duration: null
            used-frequency: 0

          @upload-files = (file, err-files) !~>
            console.log file
            @test-plan.doc.doc-name = file.name

          @create-plan = !~>
            @test-plan.status = 'editable'
            console.log 'new-test-plan: ', @test-plan
            api.create-plan @test-plan .then (res) !->
              console.log 'res: ' + res.status
              $state.go 'app.test.plans'
              $mdToast.show(
                $mdToast.simple()
                  .textContent('创建测试计划成功！')
                  .position('top right')
                  .hideDelay(3000)
              );

            # server-url = 'http://baidu.com' #开发时使用
            # console.log '上传文件url: ' + server-url
            # console.log '需完善服务端api方能上传文件'
            # return

            # file = $scope.plan-doc
            # if file
            #   file.upload = Upload.upload url: server-url
            #     , data:
            #       testPlanName: test-plan.name
            #       testPlanManualOperationCount: test-plan.manualOperationCount
            #       testPlanType: test-plan.type
            #       file: file
            #   file.upload.then ((response)!->
            #     $timeout ->
            #       $state.go 'app.test.plan-list', {userId: @current-user-id}),
            #     ((response)!->
            #       if response.status > 0
            #         $scope.error-msg = response.status + ':' + response.data
            #       $state.go 'app.test.plan-list', {userId: @current-user-id}),
            #     (evt)!->
            #       file.progress =  Math.min 100, parse-int 100.0 * evt.loaded / evt.total

  }
