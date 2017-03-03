'use strict'
angular.module 'app.test'

.config ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider) !->
  'ngInject'
  $state-provider.state 'app.test.plans', {
    url: '/plans'
    resolve:
      plans: (api-resolver) ->
        api-resolver.resolve 'retrievePlans@get' .then (plans) ->
          console.log 'plans: ', plans
          plans
    views:
      'content@app':
        template-url: 'app/main/test/plan/list/test-plan-list.html'
        controller-as: 'vm'
        controller: (socket-manager, plans, $state, $scope, $root-scope) !->

          @plans = plans.data
          @plans = @plans.sort (a, b)-> (new Date b.doc-create-date).get-time! - (new Date a.doc-create-date).get-time!
          @plans = @plans.map (plan)->
            plan.expectedExecuteDuration = Math.floor(Math.random() * 40) + 20
            plan
          console.log '@plans: ', @plans

          @dt-options =
            dom         : '<"top"f>rt<"bottom"<"left"<"length"l>><"right"<"info"i><"pagination"p>>>'
            paging-type : 'simple'
            auto-width  : false
            responsive  : true

          for plan in @plans
            if plan.passes is 0 and plan.fails is 0
              plan.success-rate = '暂无记录'
            else
              plan.success-rate = (plan.passes / (plan.fails+plan.passes) * 100).to-fixed(2)
              plan.success-rate += '%'

          @go-to-plan-detail = (plan-id) !->
            socket-manager.init-socket 'http://localhost:3000'
            socket-manager.leave-rooms!
            $state.go 'app.test.plan-detail', {plan-id: plan-id}


          # @socket = socket-manager.init-socket('http://localhost:3000')

          # @config =
          #   test-package  : 'driven-test-plans'
          #   package-name  : '../node_modules/midea-kitchen-tests/bin/b36'
          #   test-name     : 'soak' # soak eco  glass  normal  rapid  one-hour
          # console.log 'config: ', @config
          # # @rooms = ['room1']
          # # socket-manager.join-rooms @rooms
          # socket-manager.start-test @config
          # console.log 'have emit start-test'
          # debugger

          # $scope.show-advanced = (ev)!->
          #   useFullScreen = ($mdMedia('sm') || $mdMedia('xs'))  && $scope.customFullscreen
          #   $mdDialog.show controller: DialogController
          #     , templateUrl: 'app/main/test/plan/list/dialog/dialog.tpml.html'
          #     , parent: angular.element(document.body)
          #     , targetEvent: ev
          #     , clickOutsideToClose:true
          #     , fullscreen: useFullScreen


          #   .then ((answer)!->
          #     $scope.status = 'You said the information was "' + answer + '".'),
          #     ->
          #       $scope.status = 'You cancelled the dialog.'

          #   $scope.$watch (->
          #     $mdMedia 'xs' || $mdMedia 'sm'),
          #     (wantsFullScreen)!->
          #       $scope.customFullscreen = (wantsFullScreen === true)

  }

