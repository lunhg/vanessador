app = angular.module("vanessador", [])

onAuth = ($scope, $http) ->
        $scope.firebaseUser = null
        $scope.error = null
        
        onErr  = (err) ->  $scope.error = err
        onUser = (response) ->
                console.log response
                
        
        onSignout = ->
                $scope.firebaseUser = null
                $scope.error = null
                
        $scope.login = ->
                $http({
                        method:'POST'
                        url: '/login'
                        headers:
                                'Content-Type': 'multipart/form-data'
                        data:
                                email: document.getElementById('loginEmail').text
                }).then(onUser).catch(onErr)

        $scope.logout = ->            
                $http({
                        method:'GET'
                        url: '/logout'
                }).then(onSignout).catch(onErr)
                
app.controller "AuthCtrl", ['$scope', '$http', onAuth]

