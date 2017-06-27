app = angular.module("vanessador", [])

onAuth = ($scope, $http) ->
        $scope.firebaseUser = null
        $scope.error = null
        
        onErr  = (err) ->  $scope.error = err
        onUser = (user) -> $scope.firebaseUser = user
        
        onSignout = ->
                $scope.firebaseUser = null
                $scope.error = null
                
        $scope.login = ->
                $http({
                        method:'GET'
                        url: '/auth'
                }).then(onUser).catch(onErr)

        $scope.logout = ->            
                $http({
                        method:'GET'
                        url: '/logout'
                }).then(onSignout).catch(onErr)
                
app.controller "AuthCtrl", ['$scope', '$http', onAuth]

