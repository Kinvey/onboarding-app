class SignedUpCtrl extends Controller

  @inject '$scope', '$state', '$stateParams', '$kinvey'

  logout: (username, password) ->
    @$scope.working = true
    @$kinvey.User.logout()
    .then (=> @didLogout()), (error) => @failedLogout error

  didLogout: ->
    @$scope.working = false
    parent.postMessage (name: 'loggedOut'), @$stateParams.origin
    @$state.go 'signup', @$stateParams

  failedLogout: (err) ->
    @$scope.working = false
    @$scope.error = err

    

class SignedUpState extends State

  name: 'signed-up'
  url: '/signed-up/?appKey&appSecret&host&origin'
  templateUrl: 'html/signed-up.html'
  controller: SignedUpCtrl

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      $kinvey.API_ENDPOINT = $stateParams.host
      $kinvey.init
        appKey: $stateParams.appKey
        appSecret: $stateParams.appSecret
    ]

new SignedUpState().register 'app'