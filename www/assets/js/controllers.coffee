"use strict"
app1 = angular.module("myApp.controllers", [])

app1.controller "menuController", ['$scope', '$location', '$rootScope', ($scope, $location, $rootScope) ->
  $scope.openLeft = () ->
    $scope.sideMenuController.toggleLeft()
]


app1.controller "SignInController", ['$scope', '$http', 'User', '$location', '$rootScope', 'formsService', 'fieldsService', ($scope, $http, User, $location, $rootScope, formsService, fieldsService) ->
  $scope.signIn = (user) ->
    data = 
      email: user.email
      secret: CryptoJS.SHA512(user.email + 'oneform.in' + user.password).toString()
    success = (data, status, headers, config) ->
      if data.result?
        console.log(User)
        User.data = data.result
        User.authenticated = true
        console.log(User.data)
        console.log("Auth:")
        console.log(User.authenticated)
        $rootScope.$apply()
        successForms = (data, status, headers, config) ->
          if data.result?
            console.log(data.result)
            formsService.orderedData = data.result
            formData = {}
            $rootScope.$apply()
            $location.path("/all_forms")
            for form in data.result
              formData[form._id] = form
            formsService.data = formData
        make_request("/forms", "GET", null, successForms)
        successFields = (data, status, headers, config) ->
          if data.result?
            console.log(data.result)
            fieldData = {}
            for field in data.result
              fieldData[field._id] = field
            fieldsService.data = fieldData
            $rootScope.$apply()
        make_request("/fields", "GET", null, successFields)
      else
        raise_error_message("Incorrect email & password combination")

    make_request("/auth/users", "POST", data, success)


]

app1.controller "SignUpController", ['$scope', '$location', '$rootScope', ($scope, $location, $rootScope) ->
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
        $rootScope.$apply()
      make_request("/users", "POST", data, success)
    else
      raise_error_message("Required fields missing")
]

app1.controller "FormController", [ '$scope', '$routeParams', 'User', 'formsService', 'fieldsService', ($scope, $routeParams, User, formsService, fieldsService)->
  $scope._id = $routeParams._id
  console.log($scope._id)
  console.log(formsService)
  console.log(fieldsService)
  $scope.fields = []
  for field_id in formsService.data[$scope._id].fields
    $scope.fields.push(fieldsService.data[field_id])
  console.log($scope.fields)

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
app1.controller "FormDisplayController", ['$scope', 'formsService', ($scope, formsService) ->
    console.log (formsService)
    $scope.forms = formsService.orderedData
]
