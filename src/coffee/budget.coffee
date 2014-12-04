###
Copyright (c) 2008-2014, Kinvey, Inc. All rights reserved.

This software contains valuable confidential and proprietary information of
KINVEY, INC and is subject to applicable licensing agreements.
Unauthorized reproduction, transmission or distribution of this file and its
contents is a violation of applicable laws.
###

class BudgetCtrl extends Controller

  @inject '$scope', '$state', '$stateParams', '$kinvey', '$interval', 'reports', 'PubNub'

  initialize: ->

    @$scope.reports = @reports

    @PubNub.ngSubscribe channel: @$stateParams.appKey

    @$scope.$on @PubNub.ngMsgEv(@$stateParams.appKey), (event, payload) =>

      if payload.message.type is 'script-saved'
        @$scope.execute()

      else if payload.message.type is 'new-report'
        @$scope.reports.push payload.message.report
        @$scope.execute()

  execute: ->
    @PubNub.ngPublish
      channel: @$stateParams.appKey
      message:
        type: 'execute-begin'
    @$kinvey.execute 'budget-check'
    .then (budget) =>
      @$scope.budget = budget
      @PubNub.ngPublish
        channel: @$stateParams.appKey
        message:
          type: 'execute'
          message: budget

  nu: ->
    @$state.go 'new-report', @$stateParams



  class BudgetState extends State

    name: 'budget'
    url: '/budget/?appKey&appSecret&masterSecret&host&origin'
    templateUrl: 'html/budget.html'
    controller: BudgetCtrl

    resolve:
      $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
        $kinvey.API_ENDPOINT = $stateParams.host
        $kinvey.init
          appKey: $stateParams.appKey
          masterSecret: $stateParams.masterSecret
          appSecret: $stateParams.appSecret
      ]

      reports: ['$kinvey', '$k', ($kinvey) ->
        $kinvey.DataStore.find 'expense-reports'
      ]

  new BudgetState().register 'app'
  