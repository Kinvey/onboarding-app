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
        appSecret: $stateParams.appSecret
      .then ->
        $kinvey.User.logout() if $kinvey.getActiveUser()?
    ]

new LoginState().register 'app'