(ng = angular)

.module 'app.state'
.constant 'app.state.logged-in',

  name: 'logged-in'
  url: '/logged-in/?appKey&appSecret'
  templateUrl: 'html/logged-in.html'
  controller: 'app.control.logged-in'

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      $kinvey.API_ENDPOINT = "https://v3yk1n-kcs.kinvey.com"
      $kinvey.init
        appKey: $stateParams.appKey
        appSecret: $stateParams.appSecret
    ]