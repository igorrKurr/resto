var app = angular.module('myApp', []);

app.controller('MyCtrl', function($scope, $http) {

  $http.get('/entries/').success(function(data) {
    $scope.items = data;
  });

  $scope.getEntries = function (url) {
    $http.get('/entries/' + url).success(function(data) {
      $scope.items = data;
    });
  }

});
