"use strict"
app1 = angular.module("myApp.controllers", [])

app1.controller "LogoutController", ['$scope', '$location', 'localStorageService', 'UserService', ($scope, $location, localStorageService, UserService) ->
  console.log("logging out")
  localStorageService.clearAll()
  User.authenticated = false
  $location.path("/sign_in")
]


app1.controller "SignInController", ['$scope', '$http', 'User', '$location', '$rootScope',\
 'formsService', 'fieldsService','localStorageService', \
 ($scope, $http, User, $location, $rootScope, formsService, fieldsService, localStorageService) ->
  
  $scope.signIn = (user, email, secret) ->
    console.log (email)
    console.log (secret)
    console.log ("authenticating3")
    if email? and secret?
      console.log ("authenticating2")
      data = 
        email: email
        secret: secret
    else
      data = 
        email: user.email
        secret: CryptoJS.SHA512(user.email + 'oneform.in' + user.password).toString()
      localStorageService.add('email',data["email"])
      localStorageService.add('secret',data["secret"])

    success = (data, status, headers, config) ->
      if data.result?
        console.log(User)
        User.data = data.result
        User.authenticated = true
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

  console.log ('localStorageService')
  local = {}
  local['email'] = localStorageService.get('email')
  local['secret'] = localStorageService.get('secret')
  console.log (local)

  if local
    console.log ("authenticating1")
    $scope.signIn("", local['email'], local['secret'])
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
      success = (data,textStatus,jqXHR) ->
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
  console.log ("scope._id, formsService, fieldsService")
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

  $scope.post_form = (_form_answers) -
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

app1.controller "MyDataController", ['$scope', 'User', ($scope, User) ->
    console.log (User)
    $scope.mydata = User.data
]