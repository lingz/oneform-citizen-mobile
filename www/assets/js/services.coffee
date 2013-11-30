"use strict"

srv = angular.module('myApp.services', [])
srv.factory('User', ()->
  info =
    data: null
    authenticated: null
  return info
)
