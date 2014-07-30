(ng = angular)

.module 'app.state'
.constant 'app.state.login',

  name: 'login'
  url: '/login/?appKey&appSecret'
  templateUrl: 'html/login.html'
  controller: 'app.control.login'

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      $kinvey.API_ENDPOINT = "https://v3yk1n-kcs.kinvey.com"
      $kinvey.init
        appKey: $stateParams.appKey
        appSecret: $stateParams.appSecret
      .then ->
        $kinvey.User.logout() if $kinvey.getActiveUser()?
    ]