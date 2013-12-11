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
# srv.factory('makeRequestService', ()->
#   return {
#     make_request: (route, type, data, success, error) ->
#       if type == "POST" or type == "PUT"
#         data = JSON.stringify(data)
#       if success == null
#         success = ()->
#       if error == null
#         error = ()->
#       $.ajax(
#         url: "http://ec2-54-218-85-114.us-west-2.compute.amazonaws.com" + route
#         contentType: "application/json"
#         data: data
#         type: type
#         success: success
#         error: (jqXHR, textStatus, errorThrown) ->
#           console.log('ERROR: ' + errorThrown)
#           raise_error_message(errorThrown+": "+textStatus)
#       )
#   } 
# )
