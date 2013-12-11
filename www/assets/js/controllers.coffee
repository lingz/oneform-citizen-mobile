"use strict"
app1 = angular.module("myApp.controllers", [])


app1.controller "LogoutController", ['$scope', '$location', 'localStorageService', 'User', ($scope, $location, localStorageService, User) ->
  console.log("logging out")
  localStorageService.clearAll()
  User.authenticated = false
  $location.path("/sign_in")
]

app1.controller "menuController", ['$scope', '$location', '$rootScope', ($scope, $location, $rootScope) ->
  $scope.closeLeft = () ->
    $scope.sideMenuController.close()
  $scope.toggleLeft = () ->
    $scope.sideMenuController.toggleLeft()
  $scope.isLoading = false
  $scope.loadingMessage = ""
  $scope.$on("$routeChangeSuccess", () ->
    console.log("running")
    $scope.closeLeft()
  )
]

app1.controller "SignInController", ['$scope', '$http', 'User', '$location', '$rootScope',\
 'formsService', 'fieldsService','localStorageService',\
 ($scope, $http, User, $location, $rootScope, formsService, fieldsService, localStorageService) ->
  
  $scope.user =
    email:
      name: "Email"
      _id: "userEmail"
      value: ""
    secret:
      name: "Password"
      _id: "userPassword"
      value: ""
  $scope.signIn = (user, email, secret) ->
    console.log (email)
    console.log (secret)
    console.log(user)
    console.log ("authenticating3")
    if email? and secret?
      console.log ("authenticating2")
      data =
        email: email
        secret: secret
    else
      data =
        email: user.email.value
        secret: CryptoJS.SHA512(user.email.value + 'oneform.in' + user.secret.value).toString()
      localStorageService.add('email',data["email"])
      localStorageService.add('secret',data["secret"])

    success = (data, status, headers, config) ->
      if data.result?
        console.log ("user")
        console.log(User)
        console.log("data")
        console.log (data.result)
        User.data = data.result
        User.data['secret'] = secret
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

  if local.email? and local.secret?
    console.log ("authenticating1")
    $scope.signIn("", local['email'], local['secret'])
]

app1.controller "SignUpController", ['$scope', '$location', '$rootScope', ($scope, $location, $rootScope) ->
  $scope.userSignUp= {}
  $scope.user =
    firstName:
      name: "First Name"
      id: "firstName"
    lastName:
      name: "Last Name"
      id: "lastName"
    email:
      name: "Email"
      id: "email"
    uniqueId:
      name: "UDID (Emirates Id Number)"
      id: "internalId"
    password:
      name: "Password"
      id: "password"

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

app1.controller "FormController", [ '$scope', '$routeParams', 'User', 'formsService', 'fieldsService',\
($scope, $routeParams, User, formsService, fieldsService)->
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
      data =
        id: UserService.data["id"]
        secret: UserService.secret
      # make_request("/users/:id", POST, data, success)

  $scope.post_form = () ->
    console.log ("thsisi")
    console.log (User)
    fieldData = $scope.fields
    if fieldData?
      console.log (true)
      $scope.status = "sending"
      succesfullUpload = true
      for field in fieldData
        data =
          _id: User['data']['_id']
          secret: User['data']['secret']
          fieldId: field._id
          value: field.value
        console.log (data)
        route = "/users/"+User['data']['_id']+"/data"
        success = (data,textStatus,jqXHR) -> 
          console.log ("data result")
          console.log (data)
          if data.status != 200
            succesfullUpload = false
          $scope.status = "confirmed"    
          console.log("success")
        make_request(route,"POST", data ,success) 
      if succesfullUpload == true
        routeForm = "/users/"+User['data']['_id']+"/forms"
        dataForm =
          _id: User['data']['_id']
          secret: User['data']['secret']
          formId: $scope._id
        make_request(routeForm,"POST", data, success)
      else
        raise_error_message("Error uploading form")
    else
      raise_error_message("Required fields missing")

]


app1.controller "FormDisplayController", ['$scope', 'formsService', ($scope, formsService) ->
    $scope.query =
      name: "Search"
      _id: "formSearch"
    console.log (formsService)
    $scope.forms = formsService.orderedData
]


app1.controller "MyDataController", ['$scope', 'User', 'fieldsService', ($scope, User, fieldsService) ->
    console.log (User)
    mydata = {'profile':[],'data':[]}
    console.log ("MYUSER")
    console.log (fieldsService)
    for key, value of User['data']['profile']
      mydata['profile'].push([key,value])
    for key, value of User['data']['data']
      console.log 
      mydata['data'].push([fieldsService['data'][key]['name'],value['value']])
    $scope.mydata = mydata
    console.log ("MYDATA2")
    console.log ($scope.mydata)
    console.log (fieldsService)
]

