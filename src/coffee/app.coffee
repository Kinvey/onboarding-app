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