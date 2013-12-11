window.serverAddress = "http://ec2-54-218-85-114.us-west-2.compute.amazonaws.com"

window.make_request = (route, type, data, success, error) ->
 
  if type == "POST" or type == "PUT"
    data = JSON.stringify(data)
  if success == null
    success = ()->
  if error == null
    error = ()->
  $.ajax(
    url: serverAddress + route
    contentType: "application/json"
    data: data
    type: type
    success: success
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('ERROR: ' + errorThrown)
      raise_error_message(errorThrown+": "+textStatus)
      )

window.raise_error_message = (error_str) ->
  $("#error-content").html(error_str)
  $('#errors').addClass("raised")
  setTimeout(() ->
    $("#errors").removeClass("raised")
  , 3000)
