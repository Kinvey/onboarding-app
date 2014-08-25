###
Copyright (c) 2008-2014, Kinvey, Inc. All rights reserved.

This software contains valuable confidential and proprietary information of
KINVEY, INC and is subject to applicable licensing agreements.
Unauthorized reproduction, transmission or distribution of this file and its
contents is a violation of applicable laws.
###

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
      @back()

  back: ->
    @$state.go @$state.previous.name, @$state.previous.params



class NewReportState extends State

  name: 'new-report'
  url: '/new-report/?appKey&masterSecret&appSecret&host&origin'
  templateUrl: 'html/new-report.html'
  controller: NewReportCtrl

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      $kinvey.API_ENDPOINT = $stateParams.host
      $kinvey.init
        appKey: $stateParams.appKey
        masterSecret: $stateParams.masterSecret
        appSecret: $stateParams.appSecret
    ]

new NewReportState().register 'app'