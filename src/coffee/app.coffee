###
Copyright (c) 2008-2014, Kinvey, Inc. All rights reserved.

This software contains valuable confidential and proprietary information of
KINVEY, INC and is subject to applicable licensing agreements.
Unauthorized reproduction, transmission or distribution of this file and its
contents is a violation of applicable laws.
###

angular.module 'app', ['templates', 'ui.router', 'ui.bootstrap', 'kinvey']

  .config ['$urlRouterProvider',
    ($urlRouterProvider) ->
      $urlRouterProvider.otherwise '/'
    ]

  .run ['$rootScope', '$state',
    ($rootScope, $state) ->
      $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
        if fromState?
          $state.previous =
            name: fromState.name
            params: fromParams
  ]