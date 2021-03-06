"use strict"
isDeveloper = true

# Declare app level module which depends on filters, and services


app = angular.module("myApp", ["ionic", "myApp.filters", "myApp.services",
  "myApp.controllers", "myApp.directives", "ngRoute", "LocalStorageModule"])

app.config ["$routeProvider", ($routeProvider) ->

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

app.run ["$rootScope", "$location", "User", "fieldsService", "formsService", "localStorageService","$route",\
 ($rootScope, $location, User, fieldsService, formsService, localStorageService, $route) ->
  $rootScope.userIsAuthenticated = () ->
    if not User.authenticated
      console.log "not auth"
      if User.authenticated == false
        console.log "Running?"
        raise_error_message("You need to be signed in")
        $location.path("/sign_in")
      return false   
    return true

  $rootScope.updateUser = (userEmail, userSecret, userSuccessUpdate) ->  
    successUpdate = () ->
      if userSuccessUpdate?
        userSuccessUpdate()
      $rootScope.stopLoad()
      $rootScope.$apply()
      $route.reload()
      console.log ("Done update")

    $rootScope.successCount = 0
    
    console.log ("LOCAL")
    data = 
      email: localStorageService.get('email')
      secret: localStorageService.get('secret')
    console.log (data)

    if userEmail? and userSecret?
      data = 
        email: userEmail
        secret: userSecret
    console.log (data)

    email = data['email']
    secret = data['secret']
    if not email? or not secret? 
      $location.path("/sign_in")
      raise_error_message("You need to be signed in")
      User.authenticated = false
      return
    success = (data, status, headers, config) ->
      if data.result?
        console.log ("user")
        console.log(User)
        console.log("data") 
        console.log (data.result)
        User.data = data.result
        User.data['secret'] = secret
        User.authenticated = true
        console.log ("user")
        console.log(User)
        $rootScope.successCount += 1
        $rootScope.doneDownloading()
      else
        raise_error_message("Incorrect email & password combination")
        localStorageService.clearAll()
        User.authenticated = false
        console.log("sending to sign in")
        $location.path("/sign_in")
        $rootScope.stopLoad()
    successForms = (data, status, headers, config) ->
      if data.result?
        console.log("success here!kjhx;")
        console.log(data.result)
        formsService.orderedData = data.result
        formData = {}
        for form in data.result
          formData[form._id] = form
        formsService.data = formData
        $rootScope.successCount += 1
        $rootScope.doneDownloading()
    successFields = (data, status, headers, config) ->
      if data.result?
        console.log(data.result)
        fieldData = {}
        for field in data.result
          fieldData[field._id] = field
        fieldsService.data = fieldData
        $rootScope.successCount += 1
        $rootScope.doneDownloading()

    $rootScope.doneDownloading = () ->
      if $rootScope.successCount == 3
        localStorageService.add('email', email)
        localStorageService.add('secret', secret)
        successUpdate()
        $rootScope.successCount = 0

    make_request("/fields", "GET", null, successFields)
    make_request("/forms", "GET", null, successForms)
    make_request("/auth/users", "POST", data, success)
  
  $rootScope.$watch(
    => $location.path(),
    (next, prev) ->
      console.log "Local STORAGE"
      console.log(localStorageService)
      console.log $location.path().search("sign") == -1
      if not User.authenticated and not ($location.path().search("sign") != -1 or $location.path() == "/")
        console.log("getting")
        $rootScope.updateUser()
        console.log $location.path()
  )
]
