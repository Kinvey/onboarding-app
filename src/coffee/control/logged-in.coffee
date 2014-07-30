(ng = angular)

.module 'app.control'
.controller 'app.control.logged-in', [

  '$scope', '$state', '$stateParams', '$kinvey',
  ($scope, $state, $stateParams, $kinvey) ->

    @params = $stateParams
    @state = $state
    @scope = $scope

    @didLogout = =>
      @state.go 'login', @params

    @failedLogout = (err) =>
      @scope.error = err

    @scope.logout = (username, password) =>
      $kinvey.User.logout()
      .then @didLogout, @failedLogout
]