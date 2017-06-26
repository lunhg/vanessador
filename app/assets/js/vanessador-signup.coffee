AuthorizationService = ($http) ->
        vm = {}
        vm.signup = (email, username) ->
                $http({
                        method:'POST',
                        url:'/signup',
                        headers:
                                'Authorization': "Basic #{window.btoa(email+":"+username)}"
                })

        vm.login = (emailOrUsername, pwd) ->
                $http({
                        method:'POST',
                        url:'/login',
                        headers:
                                'Authorization': "Basic #{window.btoa(emailOrUsername+":"+pwd)}"
                })
                        
        vm.logout = ->
                $http({
                        method:'POST',
                        url:"/users/logout",
                })

vanessador.service 'AuthorizationService',  ['$http', AuthozrizationService]
