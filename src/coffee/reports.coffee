class ReportsCtrl extends Controller

  @inject '$scope', '$state', '$stateParams', '$kinvey', '$interval', 'reports'

  initialize: ->

    @$scope.reports = @reports

    @$interval (=>
      @$kinvey.DataStore.find 'expense-reports'
      .then (reports) => @$scope.reports = reports
    ), 2000

  nu: ->
    @$state.go 'new-report', @$stateParams



class ReportsState extends State

  name: 'reports'
  url: '/reports/?appKey&appSecret&host&origin'
  templateUrl: 'html/reports.html'
  controller: ReportsCtrl

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      $kinvey.API_ENDPOINT = $stateParams.host
      $kinvey.init
        appKey: $stateParams.appKey
        masterSecret: $stateParams.appSecret
    ]

    reports: ['$kinvey', '$k', ($kinvey) ->
      $kinvey.DataStore.find 'expense-reports'
    ]

new ReportsState().register 'app'