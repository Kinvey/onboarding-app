class SignupCtrl extends Controller

  @inject '$scope', '$state', '$stateParams', '$kinvey'

  signup: (username, password) ->
    @$scope.working = true
    @$kinvey.User.signup
      username: username
      password: password
    .then (=> @didSignup()), (error) => @failedSignup error

  didSignup: ->
    @$scope.working = false
    parent.postMessage (name: 'signedUp'), @$stateParams.origin
    @$state.go 'signed-up', @$stateParams

  failedSignup: (err) ->
    @$scope.working = false
    @$scope.error = err

    

class SignupState extends State

  name: 'signup'
  url: '/signup/?appKey&appSecret&host&origin'
  templateUrl: 'html/signup.html'
  controller: SignupCtrl

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      console.log $stateParams
      $kinvey.API_ENDPOINT = $stateParams.host
      $kinvey.init
        appKey: $stateParams.appKey
        appSecret: $stateParams.appSecret
      .then ->
        $kinvey.User.logout() if $kinvey.getActiveUser()?
    ]

new SignupState().register 'app'