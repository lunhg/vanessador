app = angular.module("vanessador", [])

onAuth = ($scope, $http) ->

        $scope.user = null
        $scope.iconGoogle = "https://cdn4.iconfinder.com/data/icons/new-google-logo-2015/400/new-google-favicon-16.png"
        $scope.iconFacebook = "https://www.seeklogo.net/wp-content/uploads/2016/09/facebook-icon-preview-1.png"
        # When user logged, update authData
        $http({
                method: 'GET',
                url: '/config'
        }).then (config) ->
                if not firebase.apps.length
                        firebase.initializeApp config.data            
                        
                firebase.auth().onAuthStateChanged (user) ->
                        if user
                                $scope.user = user
                                console.log user

        # 'Private' methods 
        onErr  = (err) ->  $scope.error = err
        onSignout = -> $scope.user= null

        # 'Public' methods
        $scope.authData = null
        
        $scope.loginGoogle = ->
                if not firebase.auth().currentUser
                        provider = new firebase.auth.GoogleAuthProvider()
                        provider.addScope('https://www.googleapis.com/auth/userinfo.profile')
                        firebase.auth().signInWithPopup(provider).then (result) ->
                                $http({
                                        method: 'POST'
                                        url: '/auth/callback?provider=google&uid=#{result.user.uid}&token=#{result.token}'
                                }).catch onErr

                                
        $scope.logout = -> firebase.auth().signOut().then(onSignout).catch(onErr)

        dropping = true
        $scope.onDropmenu = ->
                if not dropping
                        document.getElementById('menu').classList.add('open')
                        dropping = true
                else
                        document.getElementById('menu').classList.remove('open')
                        dropping = false
app.controller "AuthCtrl", ['$scope', '$http', onAuth]

