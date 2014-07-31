angular.module 'app', ['templates', 'ui.router', 'ui.bootstrap', 'kinvey']

  .config ['$urlRouterProvider',
    ($urlRouterProvider) ->
      $urlRouterProvider.otherwise '/'
    ]