"use strict"
isDeveloper = true

# Declare app level module which depends on filters, and services
app = angular.module("myApp", ["ngRoute", "LocalStorageModule", "myApp.filters", "myApp.services", "myApp.controllers"])

app.config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/view1",
    templateUrl: "partials/input_fields.html"
    controller: "MyCtrl1",
    access:
      isFree: isDeveloper

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

app.run ($rootScope, $location, User) ->
  $rootScope.$watch(
    => $location.path(),
    (next, prev) ->
        if not User.authenticated and not (next is '/sign_in' or next is '/sign_up')
          $location.path("/sign_in")
  )
