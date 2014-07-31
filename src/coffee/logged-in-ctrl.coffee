class LoggedInCtrl extends Controller

  @inject '$scope', '$state', '$stateParams', '$kinvey'

  logout: (username, password) ->
    @$scope.working = true
    @$kinvey.User.logout()
    .then (=> @didLogout()), (error) => @failedLogout error

  didLogout: ->
    @$scope.working = false
    parent.postMessage (name: 'loggedOut'), @$stateParams.origin
    @$state.go 'login', @$stateParams

  failedLogout: (err) ->
    @$scope.working = false
    @$scope.error = err