"use strict"
app1 = angular.module("myApp.directives", [])

app1.directive "appVersion", ["version", (version) ->
	(scope, elm, attrs) ->
		elm.text version
	]

app1.directive "blur", ->
	(scope, element, attrs) ->
		element.bind "blur", ->
			scope.$apply(attrs.blur)

app1.directive "checkUser", ["$rootScope", "$location", "userSrv", ($root, $location, userSrv) ->
  link: (scope, elem, attrs, ctrl) ->
    $root.$on "$routeChangeStart", (event, currRoute, prevRoute) ->
      $location.path("/view1") if not prevRoute.access.isFree and not userSrv.isLogged
]

app1.directive "sidemenu", ->
  return {
    restrict: "E",
    templateUrl: "partials/sidemenu.html"
  }

app1.directive "inputForm", ->
  return {
    restrict: "E",
    transclude: true,
    templateUrl: "partials/input-form.html"
  }

dir.directive "inputField", ->
  return {
    restrict: "E",
    templateUrl: "partials/input-field.html",
    scope: {
      field: "=field",
      keyup: "&"
    }
    link: (scope, element, attrs) ->
      scope.keyup = ($event) ->
        scope.field = element.find("input").val()
      scope.htmltype = if attrs.htmltype? then attrs.htmltype else "text"
      scope.disabledstate = attrs.disabledstate
      scope.description = attrs.description
      scope.label = attrs.label
      scope._id = if attrs._id? then attrs._id else attrs.label + "id"
  }

app1.directive "bigQuery", ->
  return {
    restrict: "E",
    templateUrl: "partials/big-query.html",
    scope: {
      fieldInfo: "=field",
      keyup: "&"
    }
    link: (scope, element, attrs) ->
      scope.keyup = ($event) ->
        scope.fieldInfo.value = element.find("input").val()
  }
