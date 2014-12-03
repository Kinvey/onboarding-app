###
Copyright (c) 2008-2014, Kinvey, Inc. All rights reserved.

This software contains valuable confidential and proprietary information of
KINVEY, INC and is subject to applicable licensing agreements.
Unauthorized reproduction, transmission or distribution of this file and its
contents is a violation of applicable laws.
###

class ReportsCtrl extends Controller

  @inject '$scope', '$state', '$stateParams', '$kinvey', '$interval', 'reports', 'PubNub'

  initialize: ->

    @$scope.reports = @reports

    @PubNub.ngSubscribe channel: @$stateParams.appKey

    @$scope.$on @PubNub.ngMsgEv(@$stateParams.appKey), (event, payload) ->

      if payload.message.type is 'new-report'
        @$scope.reports.push payload.message.report

  select: (report) ->
    report.selected = not report.selected

  approve: (report) ->
    @PubNub.ngPublish
      channel: @$stateParams.appKey
      message:
        type: 'alert-begin'
    promise = @$kinvey.execute 'approve',
        report: report
        user: @$kinvey.getActiveUser()
    promise.then =>
      @PubNub.ngPublish
        channel: @$stateParams.appKey
        message:
          type: 'alert'


  reject: (report) ->
    @$kinvey.execute 'reject', report

  nu: ->
    @$state.go 'new-report', @$stateParams

  signup: ->
    @$state.go 'signup', @$stateParams



class ReportsState extends State

  name: 'reports'
  url: '/reports/?appKey&appSecret&masterSecret&host&origin'
  templateUrl: 'html/reports.html'
  controller: ReportsCtrl

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

new ReportsState().register 'app'