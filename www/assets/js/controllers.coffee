"use strict"
app1 = angular.module("myApp.controllers", [])


app1.controller "LogoutController", ['$scope', '$location', 'localStorageService', 'User', ($scope, $location, localStorageService, User) ->
  console.log("logging out")
  localStorageService.clearAll()
  User.authenticated = false
  $location.path("/sign_in")
]

app1.controller "menuController", ['$scope', '$location', '$rootScope', 'User', ($scope, $location, $rootScope, User) ->
  $scope.appLoaded = false
  $scope.closeLeft = () ->
    $scope.sideMenuController.close()
  $scope.toggleLeft = () ->
    $scope.sideMenuController.toggleLeft()
  $scope.isLoading = true
  $scope.loadingMessage = "oneForm"
  $scope.$on("$routeChangeSuccess", () ->
    console.log("running")
    $scope.$broadcast('scroll.resize')
    $scope.closeLeft()
  )
  $rootScope.startLoad = (loadingMessage) ->
    $scope.isLoading = true
    $scope.loadingMessage = if loadingMessage then loadingMessage else "Loading..."

  $rootScope.stopLoad = () ->
    $scope.appLoaded = true
    $scope.isLoading = false
    $scope.loadingMessage = "Loading..."
    phase = $scope.$root.$$phase
    if phase != "$apply" and phase != "$digest"
      $rootScope.$apply()

  $rootScope.appReady = () ->
    $rootScope.appLoaded = true

  $rootScope.appUnready = () ->
    $scope.appLoaded = false

  $scope.onRefresh = () ->
    if not User.authenticated
      $scope.$broadcast('scroll.refreshComplete')
      return  
    $rootScope.updateUser(null,null,()->
        raise_error_message("Successful Update")
    )
]

app1.controller "SignInController", ['$scope', '$http', 'User', '$location', '$rootScope',\
 'formsService', 'fieldsService','localStorageService',\
 ($scope, $http, User, $location, $rootScope, formsService, fieldsService, localStorageService) ->
  

  $scope.signIn = (user, email, secret) ->
    if not (email? and secret?)
      email = user.email
      secret = CryptoJS.SHA512(user.email + 'oneform.in' + user.secret).toString()
    loadMessage = if $scope.loadingMessage then $scope.loadingMessage else "Loading..."
    $rootScope.startLoad(loadMessage)
    successUpdate = () ->
      $rootScope.appReady()
      $location.path("/all_forms")
      $rootScope.stopLoad()
      raise_error_message("Login Successful")

    $rootScope.updateUser(email, secret, successUpdate)


  local = {}
  local['email'] = localStorageService.get('email')
  local['secret'] = localStorageService.get('secret')
  console.log (local)

  if User.authenticated
    $location.path("/all_forms")
    # $rootScope.$apply()
  else if local.email? and local.secret?
    console.log ("authenticating1")
    $scope.signIn("", local['email'], local['secret'])
  else
    $rootScope.appReady()
    $rootScope.stopLoad()
]

app1.controller "SignUpController", ['$scope', '$location', '$rootScope', 'localStorageService', ($scope, $location, $rootScope, localStorageService) ->
  $rootScope.appReady()
  $rootScope.stopLoad()
  $scope.userSignUp= {}

  $scope.signUp = (user) ->
    console.log("creating user")
    console.log(user)
    console.log($scope.signUpForm.$valid)
    $rootScope.startLoad("Creating Account...")
    if $scope.signUpForm.$valid
      console.log $scope.userSignUp
      $scope.userSignUp = angular.copy(user)
      $scope.userSignUp["secret"] = CryptoJS.SHA512($scope.userSignUp["email"] + 'oneform.in' + $scope.userSignUp["password"]).toString()
      delete $scope.userSignUp["password"]
      originalData = $scope.userSignUp
      success = (data,textStatus,jqXHR) ->
        localStorageService.add('email', originalData["email"])
        localStorageService.add('secret', originalData["secret"])
        console.log("added to localStorageService")
        $location.path("/sign_in")
        $location.replace()
        $rootScope.appUnready()
        $rootScope.$apply()
      make_request("/users", "POST", originalData, success)
    else
      raise_error_message("Required fields missing")
      $rootScope.stopLoad()
]

app1.controller "FormController", [ '$scope', '$routeParams', 'User', 'formsService', 'fieldsService', '$rootScope', '$location', \
($scope, $routeParams, User, formsService, fieldsService, $rootScope, $location)->
  if not $rootScope.userIsAuthenticated()
    return
  $scope.current_form_id = $routeParams._id
  $scope.current_form = formsService['data'][$scope.current_form_id]
  console.log ("scope._id, formsService, fieldsService")
  console.log($scope.current_form_id)
  console.log(formsService)
  console.log(fieldsService)
  $scope.fields = []
  for field_id in formsService.data[$scope.current_form_id].fields
    $scope.fields.push(fieldsService.data[field_id])
  console.log("FLIEDSSSS")
  console.log($scope.fields)
#New Stuff
  console.log (User)
  $scope.mydata = []
  console.log ("MYUSER")
  console.log (User)
  for key, value of User['data']['profile']
    $scope.mydata.push({name: key, value:value, access:"Public"})
  for key, value of User['data']['data']
    $scope.mydata.push({name:fieldsService['data'][key]['name'], value: value['value'], access: value['access']})
  console.log ("MYDATA")
  console.log ($scope.mydata)
  console.log (fieldsService)
#New Stuff
  console.log ("length")
  length = $scope.fields.length
  for number in [length..0]
    number  = number - 1
    if number < 0
        console.log ("Breaking")
        break
    console.log("FIELD: ")
    console.log(number) 
    console.log ($scope.fields[number])
    console.log ("this")
    for data in $scope.mydata
      if data.name == $scope.fields[number].name
        $scope.fields[number].value = data.value
        break

  $scope.update = (fieldName,answer) ->
    if $scope.fieldName.$valid and UserService.isLogged is true
      data =
        id: UserService.data["id"]
        secret: UserService.secret
      # make_request("/users/:id", POST, data, success)

  $scope.post_form = () ->
    console.log (User)
    fieldData = $scope.fields
    if fieldData?
      $scope.status = "sending"
      succesfullUpload = true
      for field in fieldData
        successData = (data,textStatus,jqXHR) ->
          console.log ("data result")
          console.log (data)
          if data.status != 200
            succesfullUpload = false
          $scope.status = "confirmed"
          console.log ("ORGSS")
          orgsRoute = "/users/"+User['data']['_id']+"/data/"+field._id+"/orgs"
          dataOrgs = 
            _id:User['data']['_id']
            secret: User['data']['secret']
            orgs:$scope.current_form['orgs']

          #add orgs to data
          make_request(orgsRoute,"POST",dataOrgs, null, null,"OrgsResponse")
          console.log ("ORGSS DONE")
          raise_error_message("Form Submitted")
          $location.path("/mydata")
          $rootScope.$apply()

        data =
          _id: User['data']['_id']
          secret: User['data']['secret']
          fieldId: field._id
          value: field.value

        console.log (data)
        route = "/users/"+User['data']['_id']+"/data"
        #change data
        make_request(route,"POST", data ,successData)

      if succesfullUpload == true
        console.log ("form:!@")
        console.log ($scope.current_form)
        routeForm = "/users/"+User['data']['_id']+"/forms"
        dataForm =
          _id: User['data']['_id']
          secret: User['data']['secret']
          formId: $scope.current_form_id
        #add for to user
        make_request(routeForm,"POST", dataForm)
      else
        raise_error_message("Error uploading form")
        $rootScope.stopLoad()
    else
      raise_error_message("Required fields missing")
      $rootScope.stopLoad()
]


app1.controller "FormDisplayController", ['$scope', 'formsService','$rootScope', ($scope, formsService, $rootScope) ->
    if not $rootScope.userIsAuthenticated()
      return
    $scope.query =
      name: "Search"
      _id: "formSearch"
    console.log (formsService)
    $scope.forms = formsService.orderedData
]


app1.controller "MyDataController", ['$scope', 'User', 'fieldsService', '$rootScope', ($scope, User, fieldsService, $rootScope) ->
    if not $rootScope.userIsAuthenticated()
      return 
    console.log (User)
    $scope.mydata = []
    console.log ("MYUSER")
    console.log (User)
    for key, value of User['data']['profile']
      $scope.mydata.push({name: key, value:value, access:"Public"})
    for key, value of User['data']['data']
      $scope.mydata.push({name:fieldsService['data'][key]['name'], value: value['value'], access: value['access']})
    console.log ("MYDATA")
    console.log ($scope.mydata)
    console.log (fieldsService)
]

app1.controller "MyFormsController", ['$scope', 'User', 'fieldsService', 'formsService', '$rootScope', ($scope, User, fieldsService, formsService, $rootScope) ->
    if not $rootScope.userIsAuthenticated()
      return 
    console.log (User)
    mydata = {'profile':[],'data':[]}
    console.log ("MYUSER")
    console.log (User)
    for key, value of User['data']['profile']
      mydata['profile'].push({name: key, value:value})
    for key, value of User['data']['data']
      mydata['data'].push({name:fieldsService['data'][key]['name'], value: value['value'], access: value['access']})
    $scope.mydata = mydata
    console.log ("MYDATA")
    console.log ($scope.mydata)
    console.log (fieldsService)
]

