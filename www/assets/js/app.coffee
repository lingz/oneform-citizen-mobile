"use strict"
isDeveloper = true

# Declare app level module which depends on filters, and services
app = angular.module("myApp", ["ngRoute", "myApp.filters", "myApp.services", "myApp.controllers"])

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

  $routeProvider.when "/form_fill_up",
    templateUrl: "partials/userApp/form_fill_up.html"
    controller: "FormController",
      isFree: isDeveloper

  $routeProvider.when "/all_forms",
    templateUrl: "partials/userApp/allForms.html"
    controller: "FormDisplayController",
      isFree: isDeveloper

  $routeProvider.otherwise redirectTo: "/sign_in"]

app.run ($rootScope, $location, User) ->
  $rootScope.$watch(
    => $location.path(),
    (next, prev) ->
        if not User.authenticated and not (next is '/sign_in' or next is '/sign_up')
          $location.path("/sign_in")
  )
