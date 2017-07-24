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
                        
                formularioService:

                        getAll: (fn) -> firebase.database().ref('formularios/').once 'value', (snapshot) -> fn snapshot.val()

                        get: (uuid, fn) ->
                                firebase.database().ref("formularios/#{uuid}").once 'value', (snapshot) ->
                                        fn snapshot.val()

                        delete: (uuid) ->
                                onDel = -> toastr.warning('Atenção', "formulário #{uuid} deletado")
                                firebase.database().ref("formularios/#{uuid}").set(null).then(onDel)

                        novo: (id_group, groups, toaster) ->
                                o = {}
                                for e in groups
                                        if e isnt 'uuid'
                                                if e isnt 'tags'
                                                        o[e] = document.getElementById("#{id_group}_#{e}").value
                                                else
                                                        o[e] = document.getElementById("#{id_group}_#{e}").value.split(" ")


                                user = firebase.auth().currentUser
                                o.owner = user.uid
                                uuid = document.getElementById("#{id_group}_uuid").value
                                onSet = -> toastr.success('Sucesso', "formulário #{uuid} registrado")
                                firebase.database().ref("formularios/#{uuid}").set(o).then(onSet)
