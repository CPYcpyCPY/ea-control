(function ()
{
    'use strict';

    angular
        .module('fuse')
        .config(config);

    /** @ngInject */
    function config($locationProvider)
    {
        // Put your custom configurations here

        // 配置location服务
        $locationProvider.html5Mode(false);

    }

})();
