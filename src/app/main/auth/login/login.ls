'use strict'
angular.module 'app.auth.login', []

.config ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider) ->
  'ngInject'
  $translate-partial-loader-provider.add-part 'app/main/auth/login'

  $state-provider.state 'app.login', {
    url               : '/login'
    body-class        : 'login'
    views             :
      'main@'         :
        template-url  : 'app/core/layouts/content-only.html'
        controller    : 'MainController as vm'

      'content@app.login'  :
        template-url            : 'app/main/auth/login/login.html'
        controller-as           : 'vm'
        controller              : ($scope, $root-scope, authService, $state) ->

          authService.current-user = $root-scope.current-user = null

          # @form 是从登录框拿回的username和password数据
          login : -> authService.auth @form .then (result) ~>
            if result.status is 'OK'
              $state.go 'app.test.boxes'
              @invalid-user = false
            else
              @invalid-user = true
  }

.factory 'authService',  (api, $root-scope) ->
  service =
    # current-user: null
    auth: ({username, password}) ->
      api.auth.is-registed-user {username, password} .then (result) !->
        if result.status is 'OK'
          console.log '## running authService.auth'
          $root-scope.current-user = result.data
        return result

.run ($root-scope, $state, authService) !->
  console.log 'running app.auth.login'

  # $state改变时进行用户是否登录的判断
  $root-scope.$on '$stateChangeStart', (event, to-state) !->

    console.log '## $stateChangeStart to-state.name: ', to-state.name

    if !$root-scope.current-user && to-state.name is not 'app.login' then $root-scope.current-user = {username: 'admin', role: 'admin', _id: 1}

    # 开发时使用，避免每次都要登录
    # return true

    # 非开发时使用，未登录则进入登录页面
    # return if !!authService.current-user or to-state.name is 'app.login'
    # event.prevent-default!
    # $state.go 'app.login'
