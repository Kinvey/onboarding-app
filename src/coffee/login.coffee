class LoginCtrl extends Controller

  @inject '$scope', '$state', '$stateParams', '$kinvey'

  login: (username, password) ->
    @$scope.working = true
    @$kinvey.User.logout()
    .then (=> @didLogin()), (error) => @failedLogin error

  didLogin: ->
    @$scope.working = false
    parent.postMessage (name: 'loggedIn'), @$stateParams.origin
    @$state.go 'logged-in', @$stateParams

  failedLogin: (err) ->
    @$scope.working = false
    @$scope.error = err

    

class LoginState extends State

  name: 'login'
  url: '/login/?appKey&appSecret&host&origin'
  templateUrl: 'html/login.html'
  controller: LoginCtrl

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      $kinvey.API_ENDPOINT = $stateParams.host
      $kinvey.init
        appKey: $stateParams.appKey
        masterSecret: $stateParams.appSecret
      .then ->
        $kinvey.User.logout() if $kinvey.getActiveUser()?
    ]

new LoginState().register 'app'