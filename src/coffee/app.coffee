angular.module 'app', ['app.control', 'app.state', 'app.templates', 'ui.router', 'ui.bootstrap', 'kinvey']

  .config ['$urlRouterProvider',
    ($urlRouterProvider) ->
      $urlRouterProvider.otherwise '/'
    ]