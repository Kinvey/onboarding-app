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
    @$scope.working = true
    @$kinvey.User.signup
      username: username
      password: password
    .then (=> @didSignup()), (error) => @failedSignup error

  didSignup: ->
    @$scope.working = false
    parent.postMessage (name: 'signedUp'), @$stateParams.origin
    @$state.go 'signed-up', @$stateParams

  failedSignup: (err) ->
    @$scope.working = false
    @$scope.error = err

    

class SignupState extends State

  name: 'signup'
  url: '/signup/?appKey&appSecret&masterSecret&host&origin'
  templateUrl: 'html/signup.html'
  controller: SignupCtrl

  resolve:
    $k: ['$stateParams', '$kinvey', '$q', ($stateParams, $kinvey, $q) ->
      console.log $stateParams
      $kinvey.API_ENDPOINT = $stateParams.host
      $kinvey.init
        appKey: $stateParams.appKey
        masterSecret: $stateParams.masterSecret
        appSecret: $stateParams.appSecret
      .then ->
        $kinvey.User.logout() if $kinvey.getActiveUser()?
    ]

new SignupState().register 'app'