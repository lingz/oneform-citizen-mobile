"use strict"

# Declare app level module which depends on filters, and services
app = angular.module("myApp", ["ngRoute", "myApp.filters", "myApp.services", "myApp.controllers"])

app.config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/view1",
    templateUrl: "static/app/partials/input_fields.html"
    controller: "MyCtrl1",
    access:
      isFree: false

  $routeProvider.when "/sign_in",
    templateUrl: "static/app/partials/sign_in.html"
    controller: "SignInController",
      isFree: true

  $routeProvider.when "/sign_up",
    templateUrl: "static/app/partials/sign_up.html"
    controller: "SignUpController",
      isFree: true

  $routeProvider.when "/form_fill_up",
    templateUrl: "static/app/partials/userApp/form_fill_up.html"
    controller: "FormController",
      isFree: false

  $routeProvider.when "/all_forms",
    templateUrl: "static/app/partials/userApp/allForms.html"
    controller: "FormDisplayController",
      isFree: false

  $routeProvider.otherwise redirectTo: "/sign_in"]

app.run ($rootScope, $location, User) ->
  $rootScope.$watch(
    => $location.path(),
    (next, prev) ->
        if not User.authenticated and not (next is '/sign_in' or next is '/sign_up')
          $location.path("/sign_in")
  )
