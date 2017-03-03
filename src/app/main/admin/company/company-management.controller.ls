angular.module 'app.admin'

.config ($state-provider) !->
  'ngInject'

  $state-provider.state 'app.admin.companies', {
    url: '/users/:userId/admin-company',
    views:
      'content@app':
        template-url: 'app/main/admin/company/company-management.html',
        resolve:
          results: (api-resolver) -> api-resolver.resolve 'adminInfo.company@get'
        controller-as: 'vm',
        controller: ($scope, $md-dialog, results) !->

          console.log results

          # data-table参数
          @dt-options =
            dom         : '<"top"f>rt<"bottom"<"left"<"length"l>><"right"<"info"i><"pagination"p>>>'
            paging-type : 'simple'
            auto-width  : false
            responsive  : true

          # 静态数据
          @companies = results.companies

          # 弹出对话框：添加新组织
          @add-new-company-dialog = ($event) !->
            $md-dialog.show({
              controller: dialog-controller
              template-url: 'app/main/admin/company/add-new-company.html'
              parent: angular.element(document.body)
              target-event: $event
              click-outside-to-close:true
            })

          dialog-controller = ($scope, $mdDialog) !->
            $scope.hide = !->
              $mdDialog.hide!
            $scope.cancel = !->
              $mdDialog.cancel!

  }
