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
                boletoService: ['$http', 'toastr', ($http, toastr) ->

                        BoletoService = {}


                        # Referencia um boleto a um token de um formulario
                        create = (uuid, token, data) ->
                                new Promise (resolve, reject) ->
                                        console.log data
                                        url = []
                                        url.push "#{k}=#{v}" for k,v of data
                                        url = '/paypal/invoices/novo?'+url.join('&')
                                        $http.post(url).then (invoiceid)->
                                                db = firebase.database()
                                                db.ref("boletos/#{uuid}").once 'value', (boletos) ->
                                                        b =  if boletos.val() isnt null then boletos.val() else []
                                                        b.push({
                                                                token: token
                                                                invoice: invoiceid.data
                                                                status: 'DRAFT'
                                                        })
                                                        db.ref("boletos/#{uuid}").set(b).then(-> resolve invoiceid.data).catch(reject)
                                                        
                        
                        _on = (what, uuid, token,  pid) ->
                                
                                                                                                        
                        # Crie um novo boleto requisitando
                        # a API do paypal (que está no backend)
                        # e atualize os dados na base de dados
                        BoletoService.novo = (uuid, token, options)->
                                new Promise (resolve, reject) ->
                                        onCreate = (result) ->
                                                toastr.success("Boleto", "boleto #{result} criado")
                                        create(uuid, token, options).then(onCreate).then(resolve).catch reject 

                        BoletoService.status = (pid) ->
                                new Promise (resolve, reject) ->
                                        $http.post("/paypal/invoices/#{pid}/status").then (r) ->
                                                resolve r.data
                                                
                        # Crie uma suíte de requisições para o paypal
                        # - enviar uma notificação
                        BoletoService.send = (uuid, token, pid) ->
                                new Promise (resolve, reject) ->
                                                
                                        $http.post("/paypal/invoices/#{pid}/send").then (r) ->
                                                onSend = -> toastr.info("Email", r.data)
                                                BoletoService.status(pid).then (_r) ->
                                                        boletos = firebase.database().ref("boletos/#{uuid}")
                                                        boletos.once 'value', (boleto) ->
                                                                b = boleto.val()
                                                                for b in boleto.val()
                                                                        if pid is b.invoice
                                                                                if b.status != _r.data
                                                                                        b.status = _r.data
                                                                        
                                                                boletos.set(b)
                                                                        .then(onSend)
                                                                        .then(resolve)
                                                                        .catch(reject)

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
                                        onDel = -> toastr.success('Formulario',"#{uuid} deletado com sucesso")
                                        Promise.all(firebase.database().ref("#{e}/#{uuid}").set(null) for e in ['formularios', 'questions', 'responses', 'stats']).then(onDel)
                                        

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
                ]
