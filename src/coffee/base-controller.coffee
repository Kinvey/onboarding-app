###
Copyright (c) 2008-2014, Kinvey, Inc. All rights reserved.

This software contains valuable confidential and proprietary information of
KINVEY, INC and is subject to applicable licensing agreements.
Unauthorized reproduction, transmission or distribution of this file and its
contents is a violation of applicable laws.
###

class @Controller

  @register: (module, name) ->
    name ?= @name || @toString().match(/function\s*(.*?)\(/)?[1]
    (angular.module module).controller name, @

  @inject: (args...) ->
    @$inject = args

  constructor: (args...) ->
    for key, index in @constructor.$inject
      @[key] = args[index]

    for key, fn of @constructor.prototype
      continue unless typeof fn is 'function'
      continue if key in ['constructor', 'initialize'] or key[0] is '_'
      @$scope[key] = fn.bind?(@) || _.bind(fn, @)

    @initialize?()
    