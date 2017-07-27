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

                # Serviço de boletos
                boletoService: ['$http', ($http) ->

                        BoletoService = {}


                        create = (uid, options) ->
                                new Promise (resolve, reject) ->
                                        url = ['/paypal/invoices/novo?']
                                        url.push "#{k}=#{v}" for k,v in options
                                        url = url.join('&')
                                        $http.get(url).then (r1) ->
                                                firebase.database()
                                                        .ref("boletos/#{result.uid}/#{result.pid}")
                                                        .set(status: 'DRAFT')
                                                        .then ->
                                                                resolve {uid: uid, pid: r1.data.payment_id}

                        _on = (what, uid, pid) ->
                                new Promise (resolve, reject) ->
                                        $http.get('/paypal/invoices/#{pid}/#{what}').then (r1) ->
                                                $http.get('/paypal/invoices/#{pid}').then (r2) ->
                                                        firebase.database()
                                                                .ref("boletos/#{uid}/#{pid}")
                                                                .set(status:r2.data.status)
                                                                .then resolve
                                                                .catch reject
                                                                                                        
                        # Crie um novo boleto requisitando
                        # a API do paypal (que está no backend)
                        # e atualize os dados na base de dados
                        BoletoService.novo = (uid, options)->
                                new Promise (resolve, reject) ->
                                        onCreate = (result) -> resolve uid: result.uid, payment_id:result.pid
                                        create(uid, options).then(onCreate).catch reject 
                                
                        # Crie uma suíte de requisições para o paypal
                        # - enviar uma notificação
                        BoletoService.send = (uid, pid) -> new Promise (resolve, reject) -> _on('send', uid, pid).then(->resolve pid).catch(reject)

                        # - relembrar a notificação
                        BoletoService.remind = (uid, pid) -> new Promise (resolve, reject) -> _on('remind', uid, pid).then(->resolve pid).catch(reject)

                        
                        # - cancelar o pagamento
                        BoletoService.cancel = (uid, pid) -> new Promise (resolve, reject) -> _on('cancel', uid, pid).then(->resolve pid).catch(reject)
                                                
                        return BoletoService
                ]
                                
                        
                formularioService: ['$http', '$location', 'toastr', ($http, $location, toastr) ->
                                
                        FormularioService = {}

                        fetch = (uuid) ->
                                new Promise (resolve, reject) ->
                                        query = ["/typeform/data-api?"]
                                        query.push "uuid=#{uuid}"
                                        query = query.join('&')
                                        $http.get(query).then (result) ->
                                                console.log result.data
                                                resolve result.data
                                                
                                
                        FormularioService.getAll = (fn) ->
                                firebase.database().ref('formularios/').once 'value', (snapshot) ->
                                        fn snapshot.val()

                        FormularioService.get = (uuid, fn) ->
                                firebase.database().ref("formularios/#{uuid}").once 'value', (snapshot) ->
                                        fn snapshot.val()

                        FormularioService.delete = (uuid) ->
                                onDel = -> toastr.warning('Atenção', "formulário #{uuid} deletado")
                                firebase.database().ref("formularios/#{uuid}").set(null).then(onDel)

                                
                        FormularioService.novo = (id_group, groups) ->
                                # Pegue os dados do formulario e organize-os em um objeto
                                # para inserir no firebase
                                o = {}
                                for e in groups
                                        if e isnt 'uuid'
                                                if e isnt 'tags'
                                                        o[e] = document.getElementById("#{id_group}_#{e}").value
                                                else
                                                        o[e] = document.getElementById("#{id_group}_#{e}").value.split(" ")


                                # O proprietário atual do formulário
                                user = firebase.auth().currentUser
                                o.owner = user.uid

                                # uuid do typeform
                                uuid = document.getElementById("#{id_group}_uuid").value
                                
                                onSet = ->  toastr.success('Formulário', "formulário #{uuid} registrado")
                                onFetch = (form) -> firebase.database().ref("formularios/#{uuid}").set(form).then(onSet)
                                fetch(uuid).then(onFetch).then(onSet)
                                

                        return FormularioService
                ]
