class @State

  register: (module) ->
    (angular.module module).config ['$stateProvider', ($stateProvider) =>
      $stateProvider.state @name, @
    ]