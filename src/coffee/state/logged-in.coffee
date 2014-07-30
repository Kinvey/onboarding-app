(ng = angular)

.module 'app.state'
.constant 'app.state.logged-in',

  name: 'logged-in'
  url: '/logged-in/?appKey&appSecret&host'
  templateUrl: 'html/logged-in.html'
  controller: 'app.control.logged-in'

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      $kinvey.API_ENDPOINT = $stateParams.host
      $kinvey.init
        appKey: $stateParams.appKey
        appSecret: $stateParams.appSecret
    ]