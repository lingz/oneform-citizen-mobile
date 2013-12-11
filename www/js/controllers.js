// Generated by CoffeeScript 1.6.3
(function() {
  "use strict";
  var app1;

  app1 = angular.module("myApp.controllers", []);

  app1.controller("LogoutController", [
    '$scope', '$location', 'localStorageService', 'User', function($scope, $location, localStorageService, User) {
      localStorageService.clearAll();
      User.authenticated = false;
      return $location.path("/sign_in");
    }
  ]);

  app1.controller("menuController", [
    '$scope', '$location', '$rootScope', function($scope, $location, $rootScope) {
      $scope.closeLeft = function() {
        return $scope.sideMenuController.close();
      };
      $scope.toggleLeft = function() {
        return $scope.sideMenuController.toggleLeft();
      };
      $scope.isLoading = true;
      $scope.loadingMessage = "oneForm";
      return $scope.$on("$routeChangeSuccess", function() {
        console.log("running");
        return $scope.closeLeft();
      });
    }
  ]);

  app1.controller("SignInController", [
    '$scope', '$http', 'User', '$location', '$rootScope', 'formsService', 'fieldsService', 'localStorageService', function($scope, $http, User, $location, $rootScope, formsService, fieldsService, localStorageService) {
      var local;
      $scope.user = {
        email: {
          name: "Email",
          _id: "userEmail",
          value: ""
        },
        secret: {
          name: "Password",
          _id: "userPassword",
          value: ""
        }
      };
      $scope.signIn = function(user, email, secret) {
        var data, success;
        console.log(email);
        console.log(secret);
        console.log(user);
        console.log("authenticating3");
        if ((email != null) && (secret != null)) {
          console.log("authenticating2");
          data = {
            email: email,
            secret: secret
          };
        } else {
          data = {
            email: user.email.value,
            secret: CryptoJS.SHA512(user.email.value + 'oneform.in' + user.secret.value).toString()
          };
          localStorageService.add('email', data["email"]);
          localStorageService.add('secret', data["secret"]);
        }
        success = function(data, status, headers, config) {
          var successFields, successForms;
          if (data.result != null) {
            console.log("user");
            console.log(User);
            console.log("data");
            console.log(data.result);
            User.data = data.result;
            User.data['secret'] = secret;
            User.authenticated = true;
            $rootScope.$apply();
            successForms = function(data, status, headers, config) {
              var form, formData, _i, _len, _ref;
              if (data.result != null) {
                console.log(data.result);
                formsService.orderedData = data.result;
                formData = {};
                $rootScope.$apply();
                $location.path("/all_forms");
                _ref = data.result;
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                  form = _ref[_i];
                  formData[form._id] = form;
                }
                return formsService.data = formData;
              }
            };
            make_request("/forms", "GET", null, successForms);
            successFields = function(data, status, headers, config) {
              var field, fieldData, _i, _len, _ref;
              if (data.result != null) {
                console.log(data.result);
                fieldData = {};
                _ref = data.result;
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                  field = _ref[_i];
                  fieldData[field._id] = field;
                }
                fieldsService.data = fieldData;
                return $rootScope.$apply();
              }
            };
            return make_request("/fields", "GET", null, successFields);
          } else {
            return raise_error_message("Incorrect email & password combination");
          }
        };
        return make_request("/auth/users", "POST", data, success);
      };
      console.log('localStorageService');
      local = {};
      local['email'] = localStorageService.get('email');
      local['secret'] = localStorageService.get('secret');
      console.log(local);
      if ((local.email != null) && (local.secret != null)) {
        console.log("authenticating1");
        return $scope.signIn("", local['email'], local['secret']);
      }
    }
  ]);

  app1.controller("SignUpController", [
    '$scope', '$location', '$rootScope', function($scope, $location, $rootScope) {
      $scope.userSignUp = {};
      $scope.user = {
        firstName: {
          name: "First Name",
          id: "firstName"
        },
        lastName: {
          name: "Last Name",
          id: "lastName"
        },
        email: {
          name: "Email",
          id: "email"
        },
        uniqueId: {
          name: "UDID (Emirates Id)",
          id: "internalId"
        },
        password: {
          name: "Password",
          id: "password"
        }
      };
      return $scope.signUp = function(user) {
        var data, success;
        console.log($scope.signUpForm.$valid);
        if ($scope.signUpForm.$valid) {
          console.log($scope.userSignUp);
          $scope.userSignUp = angular.copy(user);
          $scope.userSignUp["secret"] = CryptoJS.SHA512($scope.userSignUp["email"] + 'oneform.in' + $scope.userSignUp["password"]).toString();
          delete $scope.userSignUp["password"];
          data = $scope.userSignUp;
          console.log(data);
          success = function(data, textStatus, jqXHR) {
            console.log("response: ");
            console.log(data);
            $location.path("/forms");
            $location.replace();
            return $rootScope.$apply();
          };
          return make_request("/users", "POST", data, success);
        } else {
          return raise_error_message("Required fields missing");
        }
      };
    }
  ]);

  app1.controller("FormController", [
    '$scope', '$routeParams', 'User', 'formsService', 'fieldsService', function($scope, $routeParams, User, formsService, fieldsService) {
      var field_id, _i, _len, _ref;
      $scope._id = $routeParams._id;
      console.log("scope._id, formsService, fieldsService");
      console.log($scope._id);
      console.log(formsService);
      console.log(fieldsService);
      $scope.fields = [];
      _ref = formsService.data[$scope._id].fields;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        field_id = _ref[_i];
        $scope.fields.push(fieldsService.data[field_id]);
      }
      console.log($scope.fields);
      $scope.update = function(fieldName, answer) {
        var data;
        if ($scope.fieldName.$valid && UserService.isLogged === true) {
          return data = {
            id: UserService.data["id"],
            secret: UserService.secret
          };
        }
      };
      return $scope.post_form = function() {
        var data, dataForm, field, fieldData, route, routeForm, succesfullUpload, success, _j, _len1;
        console.log("thsisi");
        console.log(User);
        fieldData = $scope.fields;
        if (fieldData != null) {
          console.log(true);
          $scope.status = "sending";
          succesfullUpload = true;
          for (_j = 0, _len1 = fieldData.length; _j < _len1; _j++) {
            field = fieldData[_j];
            data = {
              _id: User['data']['_id'],
              secret: User['data']['secret'],
              fieldId: field._id,
              value: field.value
            };
            console.log(data);
            route = "/users/" + User['data']['_id'] + "/data";
            success = function(data, textStatus, jqXHR) {
              console.log("data result");
              console.log(data);
              if (data.status !== 200) {
                succesfullUpload = false;
              }
              $scope.status = "confirmed";
              return console.log("success");
            };
            make_request(route, "POST", data, success);
          }
          if (succesfullUpload === true) {
            routeForm = "/users/" + User['data']['_id'] + "/forms";
            dataForm = {
              _id: User['data']['_id'],
              secret: User['data']['secret'],
              formId: $scope._id
            };
            return make_request(routeForm, "POST", data, success);
          } else {
            return raise_error_message("Error uploading form");
          }
        } else {
          return raise_error_message("Required fields missing");
        }
      };
    }
  ]);

  app1.controller("FormDisplayController", [
    '$scope', 'formsService', function($scope, formsService) {
      $scope.query = {
        name: "Search",
        _id: "formSearch"
      };
      console.log(formsService);
      return $scope.forms = formsService.orderedData;
    }
  ]);

  app1.controller("MyDataController", [
    '$scope', 'User', 'fieldsService', function($scope, User, fieldsService) {
      var key, mydata, value, _ref, _ref1;
      console.log(User);
      mydata = {
        'profile': [],
        'data': []
      };
      console.log("MYUSER");
      console.log(fieldsService);
      _ref = User['data']['profile'];
      for (key in _ref) {
        value = _ref[key];
        mydata['profile'].push([key, value]);
      }
      _ref1 = User['data']['data'];
      for (key in _ref1) {
        value = _ref1[key];
        console.log;
        mydata['data'].push([fieldsService['data'][key]['name'], value['value']]);
      }
      $scope.mydata = mydata;
      console.log("MYDATA2");
      console.log($scope.mydata);
      return console.log(fieldsService);
    }
  ]);

}).call(this);
