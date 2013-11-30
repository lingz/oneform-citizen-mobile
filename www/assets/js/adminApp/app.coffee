"use strict"

angular.module("adminApp", ["ngRoute", "adminApp.directives", "adminApp.controllers"]).config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/people",
    templateUrl: "static/app/partials/adminApp/people_main.html"
    controller: "peopleCtrl"

  $routeProvider.when "/forms",
    templateUrl: "static/app/partials/adminApp/forms_main.html"
    controller: "formsCtrl"

  $routeProvider.otherwise redirectTo: "/people"
]
