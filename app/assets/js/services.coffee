# Primeiro inicialize as rotas angular atraves
# de templates. Para recuperar esses templates, precisamos
# antes requerilos do servidor.
fetchServices = ->

        services =
                dialogService: ['$rootScope', ($rootScope) ->
                        ->
                                this.save = (type, msg) ->
                                        if firebase.auth().currentUser
                                                userid = firebase.auth().currentUser.uid
                                                firebase.database()
                                                        .ref("users/#{userid}/popup")
                                                        .set({type:type, msg:msg})
                                this.show = ->
                                        if firebase.auth().currentUser
                                                userid = firebase.auth().currentUser.uid
                                                firebase.database()
                                                        .ref("users/#{userid}/popup")
                                                        .once 'value', (snapshot) ->
                                                                $rootScope.dialogShown = true
                                                                $rootScope.dialogMessage = snapshot.value()
                                this.delete = ->
                                        if firebase.auth().currentUser
                                                userid = firebase.auth().currentUser.uid
                                                firebase.database()
                                                        .ref("users/#{userid}/popup")
                                                        .remove()
                        ]


