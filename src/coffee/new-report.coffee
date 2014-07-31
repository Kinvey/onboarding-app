class NewReportCtrl extends Controller

  @inject '$scope', '$state', '$stateParams', '$kinvey'

  initialize: ->
    @$scope.from = ''
    @$scope.amount = 0
    @$scope.reason = ''

  save: ->
    @$kinvey.DataStore.save 'expense-reports',
      from: @$scope.from
      amount: @$scope.amount
      reason: @$scope.reason
    .then =>
      @initialize()



class NewReportState extends State

  name: 'new-report'
  url: '/new-report/?appKey&appSecret&host&origin'
  templateUrl: 'html/new-report.html'
  controller: NewReportCtrl

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      $kinvey.API_ENDPOINT = $stateParams.host
      $kinvey.init
        appKey: $stateParams.appKey
        masterSecret: $stateParams.appSecret
    ]

new NewReportState().register 'app'