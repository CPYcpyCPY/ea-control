'use strict'

# -------- 功能分组 -------- #

# 定义test和admin虚状态
angular.module 'app.test' .config ($state-provider)-> $state-provider.state 'app.test', abstract: true
angular.module 'app.admin' .config ($state-provider)-> $state-provider.state 'app.admin', abstract: true


angular.module 'fuse'

.config navigations = ($state-provider, $translate-partial-loader-provider, ms-navigation-service-provider, $location-provider)!->
  'ngInject'

  console.log 'running fuse module config'

  nav = ms-navigation-service-provider

  # --------- 侧边栏：菜单 ----------- #
  nav.save-item 'test'      ,  { title : '测试',      group : true,  weight: 1 }
  nav.save-item 'test.boxes',  { title : '测试盒',    image : '/assets/images/menu/test-box.svg',  state : 'app.test.boxes',   weight   : 1 }
  nav.save-item 'test.plans',  { title : '测试计划',   image : '/assets/images/menu/test-plan.svg',  state : 'app.test.plans',  weight  : 1 }
  nav.save-item 'user',  {title : "用户"   , group: true,   weight   : 2,  class: 'user' }


.controller 'MainController', ($scope, $root-scope, ms-navigation-service, $state, auth-service)!->
  'ngInject'

  console.log '## running MainController'

  # Remove the splash screen
  $scope.$on '$viewContentAnimationEnded', (event)-> $root-scope.$broadcast 'msSplashScreen::remove' if event.target-scope.$id is $scope.$id

  # ---------- 侧边栏：用户信息展示 --------------------- #
  nav = ms-navigation-service
  if user = $root-scope.current-user
    nav.save-item 'user.profile',  { title : "#{user.username}，您好！", image : user.avatar,   state : 'app.profile',    weight   : 2,  class: 'profile' }
    nav.save-item 'user.logout',   { title : '退出',                    icon  : 'icon-logout',  state : 'app.login',      weight   : 2,  class: 'login'  } if user?
    nav.delete-item 'user.login'

  else
    nav.delete-item 'user.profile'
    nav.delete-item 'user.logout'
    nav.save-item 'user.login',  { title : '登录'   , icon: 'icon-login',   state : 'app.login',    weight   : 2,  class: 'logout' } if !user?

  # state-change-listener-stop = $root-scope.$on '$stateChangeStart', (event, to-state, from-state) !->
    # console.log '## MainController $stateChangeStart root-scope current-user: ', $root-scope.current-user

  # ---------- 侧边栏：管理员视图 ---------------------- #
  if $root-scope.current-user && $root-scope.current-user.role is 'admin'
    nav.save-item 'admin',            { title : '系统管理',  group : true,  weight : 1 }
    nav.save-item 'admin.users',      { title : '用户',     icon  : 'icon-account',                       state : 'app.admin.users',      weight : 1 }
    nav.save-item 'admin.companies',  { title : '公司',     icon  : 'icon-folder-multiple-outline',       state : 'app.admin.companies',  weight : 1 }
    nav.save-item 'admin.boxes',      { title : '测试盒',   image : '/assets/images/menu/test-box.svg',    state : 'app.admin.boxes',     weight : 1 }

  else
    nav.delete-item 'admin'
    nav.delete-item 'admin.users'
    nav.delete-item 'admin.companies'

  nav.set-folded true

  # $root-scope.$on 'destroy', !-> state-change-listener-stop!
