class BudgetCtrl extends Controller

  @inject '$scope', '$state', '$stateParams', '$kinvey', '$interval', 'reports', 'budget'

  initialize: ->

    @$scope.reports = @reports
    @$scope.budget = @budget

    @$interval (=>
      @$kinvey.DataStore.find 'expense-reports'
      .then (reports) => @$scope.reports = reports
    ), 2000

    @$scope.$watch 'reports', =>
      @$kinvey.execute 'budget-check'
      .then (budget) => @$scope.budget = budget

  class BudgetState extends State

    name: 'budget'
    url: '/budget/?appKey&appSecret&host&origin'
    templateUrl: 'html/budget.html'
    controller: BudgetCtrl

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

      budget: ['$kinvey', '$k', ($kinvey) ->
        $kinvey.execute 'budget-check'
      ]

  new BudgetState().register 'app'