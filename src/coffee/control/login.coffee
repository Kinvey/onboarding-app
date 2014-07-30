(ng = angular)

.module 'app.control'
.controller 'app.control.login', [

  '$scope', '$state', '$stateParams', '$kinvey',
  ($scope, $state, $stateParams, $kinvey) ->

    @params = $stateParams
    @state = $state
    @scope = $scope
    @origin = $stateParams.origin

    @scope.username = ""
    @scope.password = ""

    @didLogIn = =>
      parent.postMessage (name: 'logged-in'), @origin
      @state.go 'loggedIn', @params

    @failedLogIn = (err) =>
      @scope.error = err

    @scope.login = (username, password) =>
      $kinvey.User.login
        username: username
        password: password
      .then @didLogIn, @failedLogIn
]