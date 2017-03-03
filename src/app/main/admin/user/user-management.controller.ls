angular.module 'app.admin'

.config ($state-provider) !->
  'ngInject'

  $state-provider.state 'app.admin.users', {
    url: '/users/:userId/admin-user',
    views:
      'content@app':
        template-url: 'app/main/admin/user/user-management.html',
        resolve:
          results: (api-resolver) -> api-resolver.resolve 'adminInfo.user@get'
        controller-as: 'vm',
        controller: (results, $scope, $md-dialog, $md-media) !->

          # 静态数据
          @users = results.users

          # @companies = results.company.companies

          # data-table参数
          @dt-options =
            dom         : '<"top"f>rt<"bottom"<"left"<"length"l>><"right"<"info"i><"pagination"p>>>'
            paging-type : 'simple'
            auto-width  : false
            responsive  : true


          # 弹出对话框：添加单个用户
          @add-new-user-dialog = ($event) !->
            dialog-controller.companies = @companies
            $md-dialog.show({
              controller: dialog-controller
              template-url: 'app/main/admin/user/add-new-user.html'
              parent: angular.element(document.body)
              target-event: $event
              click-outside-to-close:true
            })

          # 弹出对话框：批量添加用户
          @add-user-set-dialog = ($event) !->
            dialog-controller.companies = @companies
            $md-dialog.show({
              controller: dialog-controller
              template-url: 'app/main/admin/user/add-user-set.html'
              parent: angular.element(document.body)
              target-event: $event
              click-outside-to-close:true
            })

  }

dialog-controller = ($scope, $mdDialog) !->
  if dialog-controller.companies
    $scope.companies = dialog-controller.companies
  $scope.hide = !->
    $mdDialog.hide!
  $scope.cancel = !->
    $mdDialog.cancel!
