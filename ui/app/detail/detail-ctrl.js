(function () {
  'use strict';

  angular.module('sample.detail', ['ngJsonExplorer'])
    .controller('DetailCtrl', ['$scope', 'MLRest', '$routeParams', function ($scope, mlRest, $routeParams) {
      var uri = $routeParams.uri;
      var model = {
        // your model stuff here
        detail: {}
      };

      mlRest.getDocument(uri, { format: 'json', transform: 'to-json' }).then(function(response) {
        model.detail = response.data;
      });

      angular.extend($scope, {
        model: model

      });
    }]);
}());
