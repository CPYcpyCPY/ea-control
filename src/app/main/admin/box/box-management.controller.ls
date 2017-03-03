angular.module 'app.admin'

.config ($state-provider) !->
  'ngInject'

  $state-provider.state 'app.admin.boxes', {
    url: '/users/:userId/admin-box',
    views:
      'content@app':
        template-url: 'app/main/admin/box/box-management.html',
        resolve:
          results: (api-resolver) -> api-resolver.resolve 'adminInfo.box@get'
        controller-as: 'vm',
        controller: ($scope, results, $md-dialog) !->

          console.log results
          @boxes = results.boxes

          @dt-options =
            dom         : '<"top"f>rt<"bottom"<"left"<"length"l>><"right"<"info"i><"pagination"p>>>'
            paging-type : 'simple'
            auto-width  : false
            responsive  : true

          @edit-box-info-dialog = ($event, box) !->
            console.log 'event: ', $event
            dialog-controller.boxes = @boxes
            $md-dialog.show({
              controller: dialog-controller
              template-url: 'app/main/admin/box/edit-box-info-dialog.html'
              parent: angular.element(document.body)
              target-event: $event
              click-outside-to-close:true
            })

  }

dialog-controller = ($scope, $mdDialog) !->
  if dialog-controller.companies
    $scope.companies = dialog-controller.companies
  if dialog-controller.boxes
    $scope.boxes = dialog-controller.boxes
  $scope.hide = !->
    $mdDialog.hide!
  $scope.cancel = !->
    $mdDialog.cancel!
