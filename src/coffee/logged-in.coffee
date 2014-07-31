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

    

class LoggedInState extends State

  name: 'logged-in'
  url: '/logged-in/?appKey&appSecret&host&origin'
  templateUrl: 'html/logged-in.html'
  controller: LoggedInCtrl

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      $kinvey.API_ENDPOINT = $stateParams.host
      $kinvey.init
        appKey: $stateParams.appKey
        appSecret: $stateParams.appSecret
    ]

new LoggedInState().register 'app'