###
Copyright (c) 2008-2014, Kinvey, Inc. All rights reserved.

This software contains valuable confidential and proprietary information of
KINVEY, INC and is subject to applicable licensing agreements.
Unauthorized reproduction, transmission or distribution of this file and its
contents is a violation of applicable laws.
###

class @State

  register: (module) ->
    (angular.module module).config ['$stateProvider', ($stateProvider) =>
      $stateProvider.state @name, @
    ]