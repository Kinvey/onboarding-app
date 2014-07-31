class LoginCtrl extends Controller

  @inject '$scope', '$state', '$stateParams', '$kinvey'

  login: (username, password) ->
    @$scope.working = true
    @$kinvey.User.login
      username: username
      password: password
    .then ((user) => @didLogin user), (error) => @failedLogIn error

  didLogin: (user) ->
    @$scope.working = false
    parent.postMessage (name: 'loggedIn'), @$stateParams.origin
    @$state.go 'logged-in', @$stateParams

  failedLogIn: (err) ->
    @$scope.working = false
    @$scope.error = err