# Primeiro inicialize as rotas angular atraves
# de templates. Para recuperar esses templates, precisamos
# antes requerilos do servidor.
fetchServices = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Construindo serviços..."
        services =
                dialogService:
                        save: (type, msg) ->
                                if firebase.auth().currentUser
                                        userid = firebase.auth().currentUser.uid
                                        firebase.database().ref("users/#{userid}/popup").set({type:type, msg:msg})
                        delete: ->
                                if firebase.auth().currentUser
                                        userid = firebase.auth().currentUser.uid
                                        firebase.database().ref("users/#{userid}/popup").remove()


                formulario:

                        novo: (id_group, groups) ->
                                o = {}
                                for e in groups
                                        if e isnt 'tags'
                                                v = document.getElementById("input_typeform_#{e}").value
                                                o[e] = v
                                        else
                                                _v = document.getElementById("input_typeform_#{e}").value
                                                v = _v.split(" ")
                                                o[e] = v
                                user = firebase.auth().currentUser
                                o.owner = user.uid
                                firebase.database().ref("formularios/").set(obj)
