###
Copyright (c) 2008-2014, Kinvey, Inc. All rights reserved.

This software contains valuable confidential and proprietary information of
KINVEY, INC and is subject to applicable licensing agreements.
Unauthorized reproduction, transmission or distribution of this file and its
contents is a violation of applicable laws.
###

angular.module 'app', ['templates', 'ui.router', 'ui.bootstrap', 'kinvey',
  'pubnub.angular.service']

  .config ['$urlRouterProvider',
    ($urlRouterProvider) ->
      $urlRouterProvider.otherwise '/'
    ]

  .run ['$rootScope', '$state', 'PubNub',
    ($rootScope, $state, PubNub) ->
      PubNub.init
        publish_key:'pub-c-f4f0e895-97a0-4546-ae67-1db67c68fbde',
        subscribe_key:'sub-c-c6a507fc-796c-11e4-9114-02ee2ddab7fe',
        ssl: true
  ]
  