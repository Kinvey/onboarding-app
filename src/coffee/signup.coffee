###
Copyright (c) 2008-2014, Kinvey, Inc. All rights reserved.

This software contains valuable confidential and proprietary information of
KINVEY, INC and is subject to applicable licensing agreements.
Unauthorized reproduction, transmission or distribution of this file and its
contents is a violation of applicable laws.
###

class SignupCtrl extends Controller

  @inject '$scope', '$state', '$stateParams', '$kinvey'

  signup: (username, password) ->

    PUBNUB.publish
      channel: @$stateParams.appKey
      message:
        type: 'signup-begin'

    @$scope.working = true
    @$kinvey.User.signup
      username: username
      password: password
    .then ((user)=> @didSignup user), (error) => @failedSignup error

  didSignup: (user) ->

    PUBNUB.publish
      channel: @$stateParams.appKey
      message:
        type: 'signup'
        user: user

    @$scope.working = false
    @$state.go 'new-report', @$stateParams

  failedSignup: (err) ->

    PUBNUB.ngPublish
      channel: @$stateParams.appKey
      message:
        type: 'signup-fail'

    @$scope.working = false
    @$scope.error = err

    

class SignupState extends State

  name: 'signup'
  url: '/signup/?appKey&appSecret&masterSecret&host&origin'
  templateUrl: 'html/signup.html'
  controller: SignupCtrl

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      $kinvey.API_ENDPOINT = $stateParams.host
      $kinvey.init
        appKey: $stateParams.appKey
        masterSecret: $stateParams.masterSecret
        appSecret: $stateParams.appSecret
      .then ->
        $kinvey.User.logout() if $kinvey.getActiveUser()?
    ]

new SignupState().register 'app'