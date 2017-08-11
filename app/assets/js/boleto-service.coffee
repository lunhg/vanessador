# Primeiro inicialize as rotas angular atraves
# de templates. Para recuperar esses templates, precisamos
# antes requerilos do servidor.
fetchBoletoService = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Construindo serviços..."
        
        # Serviço de boletos
        Service = ($http, $q, toastr) ->

                BoletoService = {}
        
                # Referencia um boleto a um token de um formulario
                create = (uuid, token, data) ->
                        $q (resolve, reject) ->
                                url = []
                                url.push "#{k}=#{v}" for k,v of data
                                url = '/paypal/invoices/novo?'+url.join('&')
                                $http.post(url).then (invoiceid)->
                                        BoletoService.status(invoiceid.data).then (status) ->
                                                db = firebase.database()
                                                db.ref("boletos/#{uuid}").once 'value', (boletos) ->
                                                        if boletos.val() isnt null
                                                                bol = boletos.val()
                                                        else
                                                                bol = []
                                                        bol.push({
                                                                token: token
                                                                invoice: invoiceid.data
                                                                status: status
                                                                email: data['billing_info_email']
                                                        })
                                                        db.ref("boletos/#{uuid}")
                                                                .set(bol)
                                                                .then(-> resolve invoiceid.data)
                                                                .catch(reject)
                                
                onErr  = (err) ->
                        toastr.error(err.code, err.message)
                        console.error(err.code, err.message)
                        
                # Crie um novo boleto requisitando
                # a API do paypal (que está no backend)
                # e atualize os dados na base de dados
                BoletoService.novo = (uuid, token, options)->
                        $q (resolve, reject) ->
                                onCreate = (result) -> toastr.success("Boleto", "boleto #{result} criado")
                                create(uuid, token, options).then(onCreate).then(resolve).catch reject 


                BoletoService.status = (pid) ->
                        $q (resolve, reject) ->
                                $http.get("/paypal/invoices/#{pid}/status").then( (r) ->
                                        resolve r.data
                                ).catch (e) -> toastr.error(e.code, e.message)

                                                
                # Crie uma suíte de requisições para o paypal
                # - enviar uma notificação
                BoletoService.send = (token, pid) ->
                        $q (resolve, reject) ->
                                $http.post("/paypal/invoices/#{pid}/send").then (r) ->
                                        BoletoService.status(pid).then (status) ->
                                                db = firebase.database()
                                                db.ref("boletos/").once 'value',(boletos)->
                                                        onSend = -> toastr.info("Email", r.data)
                                                        _boletos = boletos.val()
                                                        for k,v of _boletos
                                                                for b in v
                                                                        if b.token is token and b.invoice is pid and b.status is 'DRAFT'
                                                                                b.status = status
                                                                                
                                                        db.ref("boletos/").set(_boletos).then(onSend).then(resolve).catch(reject)

                BoletoService.remind = (token, pid) ->
                        $q (resolve, reject) ->
                                db = firebase.database()
                                db.ref("boletos/").once 'value', (boletos) ->
                                        onRemind = (r) ->
                                                toastr.info("Email", r.data)
                                                resolve()

                                        for k,v of boletos.val()
                                                for b in v
                                                        if pid is b.invoice
                                                                if b.status is 'SENT'
                                                                        b.status = 'REMIND'
                                                                        $http.post("/paypal/invoices/#{pid}/remind").then(onRemind).catch (e) -> toastr.error(e.code, e.message)

                BoletoService.cancel = (token, pid) ->
                        $q (resolve, reject) ->
                                $http.post("/paypal/invoices/#{pid}/cancel").then((status) ->
                                        db = firebase.database()
                                        BoletoService.status(pid).then (status) ->
                                                db.ref("boletos/").once 'value', (boletos)->
                                                        onSend = -> toastr.info("Email", status)
                                                        _boletos = boletos.val()
                                                        for k,v of _boletos
                                                                for b in v
                                                                        if b.token is token and b.invoice is pid then b.status = status
                                                        db.ref("boletos/").set(_boletos).then(onSend).then(resolve).catch(reject)
                                ).catch onErr

                Array.prototype.remove = (from, to) ->
                        rest = @slice((to or from) + 1 or @length)
                        @length = if from < 0 then @length + from else from;
                        @push.apply(this, rest)
                        
                BoletoService.delete = (form, pid, token) ->
                        $q (resolve, reject) ->
                                db = firebase.database()
                                _onBoletos = (boletos) ->
                                        _boletos = boletos.val()
                                        for i,b of _boletos
                                                _b = b.invoice is pid
                                                _b = _b and b.status is 'DRAFT'
                                                _b = _b and b.token is token
                                                if _b
                                                        delete _boletos[i]
                                                        break
                                       
                                        db.ref("boletos/").set(_boletos)
                                        
                                onDelete = (status) -> db.ref("boletos/#{form}").on('value',_onBoletos)
                                $http.delete("/paypal/invoices/#{pid}").then(onDelete)
                                        
                                        
                return BoletoService

        # Retorne um conjunto contendo a definição do serviço 
        ['$http', '$q', 'toastr', Service]
