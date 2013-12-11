"use strict"

srv = angular.module('myApp.services', [])
srv.factory('User', ()->
  info =
    data: null
    authenticated: null
  return info
)
srv.factory('formsService', ()->
  info =
    data: null
    orderedData: null
  return info
)
srv.factory('fieldsService', ()->
  return {
    data: null
  }
)
