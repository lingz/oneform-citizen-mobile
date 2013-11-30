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
