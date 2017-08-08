# Primeiro inicialize as rotas angular atraves
# de templates. Para recuperar esses templates, precisamos
# antes requerilos do servidor.
fetchFormularioService = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Construindo serviços..."
        Service =  ($http, $location, toastr) ->
                                
                FormularioService = {}
        
                fetch = (uuid) ->
                        new Promise (resolve, reject) ->
                                query = ["/typeform/data-api?completed=true"]
                                query.push "uuid=#{uuid}"
                                query = query.join('&')
                                $http.get(query).then (result) -> resolve {uuid:uuid,form:result.data}

                # popule a base de dados
                onFetch = (result) ->
                        # O proprietário atual do formulário
                        user = firebase.auth().currentUser
        
                        # Pegue os dados do formulario e organize-os em um objeto
                        # para inserir no firebase
                        o = {}
                        if FormularioService.isNovo
                                for e in ['name', 'tags', 'base_url']
                                        d = document.getElementById("input_typeform_#{e}")
                                        if e isnt 'tags' then o[e] = d.value
                                        if e is 'tags' then o[e] = d.value.split(" ")
                                dataForm =
        
                                        # Proprietário do formulário
                                        owner: user.uid
                
                                        # url de base
                                        base_url: o.base_url
                        
                                        # Propriedades gerais
                                        name: o.name
                                        tags: o.tags

                                firebase.database().ref("formularios/#{result.uuid}").set(dataForm)
                                
                        for e in ['questions', 'responses', 'stats']
                                firebase.database().ref("#{e}/#{result.uuid}").set(result.form[e]) 

                FormularioService.delete = (uuid) ->
                        new Promise (resolve, reject) ->
                                onDel = -> toastr.success('Formulario\nQuestões\nRespostas\nEstatísticas',"#{uuid} deletados com sucesso")
                                p = [
                                        firebase.database().ref("formularios/#{uuid}").set(null)
                                        firebase.database().ref("questions/#{uuid}").set(null)
                                        firebase.database().ref("responses/#{uuid}").set(null)
                                        firebase.database().ref("stats/#{uuid}").set(null)
                                ]
                                Promise.all(p).then(onDel)
                                        

                onSet = ->
                        self = this
                        new Promise (resolve, reject) ->
                                msg = "formulário #{self.uuid} #{self.type}"
                                toastr.success('Formulário', msg)
                                resolve()
                                
                FormularioService.update = (uuid) ->

                        # notificar e resolver quando terminar de criar o formulario
                        FormularioService.isNovo = false
                        fetch(uuid).then(onFetch).then(onSet.bind(uuid:uuid, type: 'atualizado'))
                                
                FormularioService.novo = (id_group, groups) ->
                        new Promise (resolve, reject) ->
                                # uuid do typeform
                                uuid = document.getElementById("input_typeform_uuid").value
                                FormularioService.isNovo = true
                                fetch(uuid).then(onFetch).then(onSet.bind(uuid:uuid, type:'criado'))
                                                                        

                return FormularioService
                
        ['$http', '$location', 'toastr', Service]

