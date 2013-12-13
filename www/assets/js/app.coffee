"use strict"
isDeveloper = true

# Declare app level module which depends on filters, and services


app = angular.module("myApp", ["ionic", "myApp.filters", "myApp.services",
  "myApp.controllers", "myApp.directives", "ngRoute", "LocalStorageModule"])

app.config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/",
    templateUrl: "index.html"
    controller: "IndexController",
    access:
      isFree: true

  $routeProvider.when "/sign_in",
    templateUrl: "partials/sign_in.html"
    controller: "SignInController",
      isFree: true

  $routeProvider.when "/sign_up",
    templateUrl: "partials/sign_up.html"
    controller: "SignUpController",
      isFree: true

  $routeProvider.when "/form/:_id",
    templateUrl: "partials/form.html"
    controller: "FormController",
      isFree: isDeveloper

  $routeProvider.when "/all_forms",
    templateUrl: "partials/allForms.html"
    controller: "FormDisplayController",
      isFree: isDeveloper

  $routeProvider.when "/mydata",
    templateUrl: "partials/mydata.html"
    controller: "MyDataController",
      isFree: isDeveloper

  $routeProvider.when "/logout",
    templateUrl: "partials/sign_in.html"
    controller: "LogoutController",
      isFree: true

  $routeProvider.otherwise redirectTo: "/sign_in"]

app.run ["$rootScope", "$location", "User", "fieldsService", "formsService", "localStorageService",\
 ($rootScope, $location, User, fieldsService, formsService, localStorageService) ->
  $rootScope.updateUser = (email, secret, successUpdate) ->
    $rootScope.updateStatus = "start"
    data = 
      email: email
      secret: secret
    success = (data, status, headers, config) ->
      $rootScope.updateStatus = "Users"
      if data.result?
        console.log ("user")
        console.log(User)
        console.log("data")
        console.log (data.result)
        User.data = data.result
        User.data['secret'] = secret
        User.authenticated = true
        successForms = (data, status, headers, config) ->
          $rootScope.updateStatus = "Forms"
          if data.result?
            console.log("success here!kjhx;")
            console.log(data.result)
            formsService.orderedData = data.result
            formData = {}
            # $rootScope.appReady()
            # $location.path("/all_forms")
            # $rootScope.stopLoad()
            # raise_error_message("Login Successful")
            for form in data.result
              formData[form._id] = form
            formsService.data = formData
            successFields = (data, status, headers, config) ->
              $rootScope.updateStatus = "Fields"
              if data.result?
                console.log(data.result)
                fieldData = {}
                for field in data.result
                  fieldData[field._id] = field
                fieldsService.data = fieldData
                successUpdate()
            make_request("/fields", "GET", null, successFields)
        make_request("/forms", "GET", null, successForms)
          
      else
        raise_error_message("Incorrect email & password combination")
        localStorageService.clearAll()
        User.authenticated = false
        $$rootScope.updateStatus = "error"
        $rootScope.stopLoad()
    make_request("/auth/users", "POST", data, success)
  
  $rootScope.$watch(
    => $location.path(),
    (next, prev) ->
      if not User.authenticated and $location.path().search("sign") == -1
        console.log $location.path()
        console.log("sending to sign in")
        $location.path("/sign_in")
  )
]