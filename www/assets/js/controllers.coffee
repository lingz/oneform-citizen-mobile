"use strict"
app1 = angular.module("myApp.controllers", [])

app1.controller "MyCtrl1", ['$scope', '$http' ,($scope, $http) ->
    $http.get("/static/forms/form1.json").success (form) ->
      $scope._form = form
    $http.get("/static/forms/user.json").success (user) ->
      $scope.user = user
    $scope.print = (str) ->
      console.log(str)
    $scope.update = (fieldName,answer) ->
      user = $scope.user
      $.ajax(
        url: location.hostname+"/users/"+user._id
        data:
          _id: user._id
          secret: user.secret
          update: ""
        type: "POST"
        success: (data,textStatus,jqXHR) ->
          console.log("success done")
        error: (jqXHR, textStatus, errorThrown) ->
          console.log('ERROR: ' + errorThrown)
        )]

app1.controller "SignInController", ['$scope', '$http', 'User', '$location', ($scope, $http, User,$location) ->
  $scope.signIn = (user) ->
    $http(
      method: 'POST'
      data:
        email: user.email
        secret: CryptoJS.SHA512(user.email + 'oneform.in' + user.password).toString()
      url: window.location.protocol + "//" + window.location.host + "/auth/users"
    ).success((data, status, headers, config) ->
      if data.result?
        console.log(User)
        User.data = data.result
        User.authenticated = true
        console.log(User.data)
        console.log("Auth:")
        console.log(User.authenticated)
        $location.path("/all_forms")
    ).error((data, status, headers, config) ->
      console.log(data)
    )

]

app1.controller "SignUpController", ['$scope', '$location',($scope, $location) ->
  $scope.userSignUp= {}
  $scope.signUp = (user) ->
    console.log($scope.signUpForm.$valid)
    if $scope.signUpForm.$valid
      console.log $scope.userSignUp
      $scope.userSignUp = angular.copy(user)
      $scope.userSignUp["secret"] = CryptoJS.SHA512($scope.userSignUp["email"] + 'oneform.in' + $scope.userSignUp["password"]).toString()
      delete $scope.userSignUp["password"]
      data = $scope.userSignUp
      console.log(data)
      success = (data,textStatus,jqXHR)->
        console.log("response: ")
        console.log(data)
        $location.path("/forms")
        $location.replace();
      make_request("/users", "POST", data, success)
    else
      raise_error_message("Required fields missing")
]

app1.controller "FormController", [ ->
  $scope.update = (fieldName,answer) ->
    if $scope.fieldName.$valid and UserService.isLogged is true
      console.log ('signed in')
      data =
        id: UserService.data["id"]
        secret: UserService.secret
      make_request("/users/:id", POST, data, success)

  $scope.post_form = (_form_answers) ->
    if $scope._form_name.$valid
      console.log $scope._form_answers
      data = $scope._form_answers
      console.log(data)
      success = ->
        #$location.path("home")
        console.log("response: ")
        console.log(data)
      make_request("/users/:id/forms", "POST", data, success)
    else
      raise_error_message("Required fields missingcd r")
]

app1.controller "FormDisplayController", ['User','$scope', '$http',(User, $scope, $http) ->
    $http(
      method: 'GET'
      url: window.location.protocol + "//" + window.location.host + "/forms"
    ).success((data, status, headers, config) ->
      if data.result?
        console.log(data.result)
        $scope.forms = data.result
        # $location.path("/all_forms")
    ).error((data, status, headers, config) ->
      console.log(data)
    )

]