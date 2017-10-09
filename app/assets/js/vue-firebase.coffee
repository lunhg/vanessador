# Valida Login
emailRE = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/


validation = -> {
        name:!!@user.name.trim()
        email:emailRE.test(@user.name)
}

isValid = ->
        val = @validation
        Object.keys(val).every (key) -> val[key]

# Login
login = ->
        id_login = 'input_login_email'
        id_password = 'input_login_password'
        self = this
        onLogin = (user) ->
                toast self.$parent, {
                        title: "Bem-vindo(a)",
                        msg: user.name or user.email
                        clickClose: true
                        timeout: 5000
                        position: "toast-top-right",
                        type: "success"
                }
        onErr = (err) ->
                toast self.$parent, {
                        title: err.code,
                        msg: err.message
                        clickClose: true
                        timeout: 5000
                        position: "toast-top-right",
                        type: "error"
                }
        email = document.getElementById(id_login).value
        if email.match(emailRE)
                firebase.auth()
                        .signInWithEmailAndPassword(email,(document.getElementById(id_password).value))
                        .then(onLogin)
                        .catch(onErr)
        else
                 toast self.$parent, {
                        title: "Email inválido",
                        msg: "Cheque se você digitou corretamente seu email na forma usuário@email.domínio"
                        clickClose: true
                        timeout: 5000
                        position: "toast-top-right",
                        type: "error"
                }
# Logout
logout = ->
        self = this
        onSignout = ->
                self.$router.push '/login'
                toast self, {
                        title: "Você saiu",
                        msg: "com sucesso do vanessador"
                        clickClose: true
                        timeout: 5000
                        position: "toast-top-right",
                        type: "success"
                }
        firebase.auth().signOut().then(onSignout).catch (err) ->
                toast self.$parent, {
                        title: err.code
                        msg: err.message
                        clickClose: true
                        timeout: 200000
                        position: "toast-top-right",
                        type: "error"
                }

# Adiciona ou remove usuários
addUser = ->
        if @isValid
                firebase.database().ref('users').push @user
                @user.name = ''
                @user.email = ''
                @user.tel = ''
                
removeUser = (user) -> firebase.database().ref('users').child(user['.key']).remove()

# Baixa formularios pre-matricula
onFormularios = (event) ->
        # Database
        db = firebase.database()
        
        query = ["/typeform/data-api?completed=true"]
        typeformcode = document.getElementById('input_typeform')
        typeformcode = typeformcode.value
        cursos = document.getElementById('input_curso')
        curso = cursos.options[cursos.selectedIndex or 0].getAttribute('data-value')
        query.push "uuid=#{typeformcode}"
        query = query.join('&')
        self = this

        # Respostas são um conjunto de respostas individuais (answers)
        onResponses = (result) ->
                new Promise (resolve, reject) ->
                        promises = []
                        for r in result.data.responses
                                promises.push db.ref("responses/#{typeformcode}/#{r.token}").set(metadata:r.metadata,answers:r.answers,completed:if r.completed is '1' then true else false) 
                        Promise.all(promises)
                                .then(->
                                        toast self.$parent, {
                                                title: "Typeform",
                                                msg: "Baixados #{result.data.responses.length} formulários de resposta"
                                                clickClose: true
                                                timeout: 120000
                                                position: "toast-top-right",
                                                type: "warning"
                                        }
                                        resolve(result)
                                )
                                .catch(->
                                        
                                        toast self.$parent, {
                                                title: "#{err.code}"
                                                msg: err.message
                                                clickClose: true
                                                timeout: 20000
                                                position: "toast-top-right",
                                                type: "error"
                                        }
                                        reject()
                                )

                                
        # Cada `answer` é um formulário pré-matricula.
        # Para cada formulário de pré-matricula temos um aluno
        # que deve ser verificado como dos tipos:
        #
        #   - 0 (não foi aluno e não tem direito a desconto no boleto)
        #   - 1 (foi aluno e tem direito a desconto de 25% no boleto)
        #   - 2 (caso excepcional com direito a 10% de desconto no boleto)
        onQuestions = (result) ->
                new Promise (resolve, reject) ->
                        promises = []
                        for q in result.data.questions
                                promises.push db.ref("questions/#{typeformcode}/#{q.id}").set(q.question)
                        Promise.all(promises)
                                .then(->
                                        toast self.$parent, {
                                                title: "Typeform #{typeformcode}",
                                                msg: "#{Object.keys(result.data.questions).length} questão(ões) registrada(s)"
                                                clickClose: true
                                                timeout: 120000
                                                position: "toast-top-right",
                                                type: "warning"
                                        }
                                        resolve(result))
                                .catch((err) ->
                                        toast self.$parent, {
                                                title: err.code,
                                                msg: err.message
                                                clickClose: true
                                                timeout: 120000
                                                position: "toast-top-right",
                                                type: "error"
                                        }
                                        reject()
                                )
                        
        # Registra formulario simples
        onRegisterForm = (result) ->
                new Promise (resolve, reject) ->
                        firebase.database()
                                .ref("formularios/#{typeformcode}")
                                .set(curso: curso)
                                .then ->
                                        toast self.$parent, {
                                                title: "Typeform",
                                                msg: "Formulário #{curso} registrado"
                                                clickClose: true
                                                timeout: 120000
                                                position: "toast-top-right",
                                                type: "warning"
                                        }
                                        resolve result
                                .catch((err) ->
                                        toast self.$parent, {
                                                title: err.code,
                                                msg: err.message
                                                clickClose: true
                                                timeout: 120000
                                                position: "toast-top-right",
                                                type: "error"
                                        }
                                        reject()
                                )

        # Registra uma Matricula
        # com o status de não matriculado, e não certificado
        # com o nome correspondente à matrícula do curso referido
        # no campo ID curso para cada resposta, que será relacionada
        # à um novo estudante
        onGetEstudantesInfo = (result) ->
                new Promise (resolve, reject) ->
                        estudantes = []
                        for r in result.data.responses
                                estudante = null
                                for q, question of result.data.questions
                                        if estudante is null then estudante = {}
                                        if estudante[question.question] is undefined
                                                estudante[question.question] = r.answers[question.id]
                                estudantes.push estudante
                        resolve estudantes

        onTrace = (estudante)->
                new Promise (resolve, reject) ->
                        _newid = uuid.v4()
                        newid = uuid.v4()
                        db.ref("traces/#{_newid}").set({
                                # Pré-criar uma matrícula
                                        id: _newid
                                        estudante:estudante['ID User']
                                        curso:curso
                                        matricula:
                                                id:newid
                                                created:false
                                        sent_mail: false
                                        paid: false
                                }).then(->
                                        toast self.$parent, {
                                                title: "Cobrança"
                                                msg: "#{_newid} criada",
                                                clickClose: true
                                                timeout: 200000
                                                position: "toast-top-right",
                                                type: "warning"
                                        }
                                ).then(resolve)
                        
                                
        onCheckEstudantes = (estudantes) ->
                new Promise (resolve, reject) ->
                        promises = []
                        make = (e) ->
                                estudante = {}
                                a = 'Email2 Email3 Gênero Telefone'
                                b = 'Nome Sobrenome Idade Profissão'
                                for p in a.split(' ')
                                        estudante[p] = "UNDEFINED"
                                for p in b.split(' ')
                                        estudante[p] = e[p]
                                estudante['ID User'] = uuid.v4()
                                estudante['Alumni(Sim_Não)'] = "Não"
                                estudante['Email1'] = e['Email']
                                estudante['Graduação'] = e['Escolaridade']
                                estudante['Cidade_Estado_País'] = "#{e['Cidade']} #{e['Estado']} Brasil"
                                estudante
                                
                        save = (e) ->
                                new Promise (_resolve, _reject) ->
                                        db.ref("/estudantes/#{e['ID User']}").set(e).then(->
                                                toast self.$parent, {
                                                        title: "Estudante"
                                                        msg: "#{e['ID User']} registrado",
                                                        clickClose: true
                                                        timeout: 200000
                                                        position: "toast-top-right",
                                                        type: "warning"
                                                }
                                        ).then(_resolve).catch(_reject)

                        db.ref("estudantes/").once('value').then((snapshot) ->
                                for e in estudantes
                                        if snapshot.val() is null
                                                estudante = make(e)
                                                promises.push save(estudante)
                                        else
                                                alreadyFound = false
                                                for k,v of snapshot.val()
                                                        if e['Email'] is v['Email1'] and not alreadyFound
                                                                alreadyFound = true
                                                                msg = "#{v['ID User']} já existe"
                                                                promises.push Promise.resolve(v).then(->
                                                                        toast self.$parent, {
                                                                                title: "Estudante"
                                                                                msg: msg
                                                                                clickClose: true
                                                                                timeout: 200000
                                                                                position: "toast-top-right",
                                                                                type: "warning"
                                                                        }
                                                                ).then(onTrace(v))
                                                        if e['Email'] is v['Email1'] and not alreadyFound
                                                                alreadyFound = true
                                                                estudante = make(e)
                                                                promises.push(save(estudante).then(onTrace(estudante)))
                        )
                                                                  
                        Promise.all(promises).then(resolve).catch((err)->
                                toast self.$parent, {
                                        title: err.code
                                        msg: err.message
                                        clickClose: true
                                        timeout: 200000
                                        position: "toast-top-right",
                                        type: "error"
                                }
                                reject()
                        )

        # * Capture o typeform
        # * popule as respostas (verificando a existência desse aluno no firebase, dando-lhe uma verificação `isAlumini={0 or 1 or 2}` para cada `answer` )
        # * e registre uma chave para cada formulario
        this.$http.get(query)
                .then onRegisterForm
                .then onQuestions
                .then onResponses
                .then onGetEstudantesInfo
                .then onCheckEstudantes

# Para cada estudante observado em traces/
# verifique se a matricula foi criada (de forma que existe um pre-registro).
# Se não tiver sido criada, utilize um pré-registro para cadastrar
# um curso e um aluno nessa matrícula.
onTraces = (traces, root) ->
        new Promise (resolve, reject) ->
                promises = []
                db = firebase.database()
                
                for k, t of traces
                        m = t.matricula.id
                        created = t.matricula.created
                        e = t.estudante
                        sent_mail = t.sent_mail
                        if not created
                                console.log created
                                promises.push(db.ref("matriculas/#{m}").set({id:m, estudante:e, curso: t.curso}).then((->
                                        db.ref("traces/#{this.t.id}/matricula/created").set(true)
                                        toast root, {
                                                title: "Matrícula"
                                                msg: "#{this.m} registrada",
                                                clickClose: true
                                                timeout: 200000
                                                position: "toast-top-right",
                                                type: "warning"
                                        }
                                ).bind(t:t, m:m)).then((->
                                        self = this
                                        new Promise (resolve, reject) ->
                                                ref = "estudantes/#{self.t.estudante}"
                                                email = {}
                                                self = this
                                                db.ref(ref).once('value').then( (e) ->
                                                        estudante = e.val()
                                                        console.log estudante
                                                        email.to = estudante['Email1']
                                                        email.nome = estudante['Nome']
                                                        email.nome += " #{estudante['Sobrenome']}"
                                                        resolve email
                                                ).catch reject
                                ).bind(t:t)).then(((email) ->
                                        self = this
                                        new Promise (resolve, reject) ->
                                                ref = "cursos/#{self.t.curso}"
                                                db.ref(ref).once('value').then (c) ->
                                                        _curso = c.val()
                                                        email.curso = _curso['Nome do curso']
                                                        if e['Alumni(Sim_Não)'] is "Sim"
                                                                email.link = _curso['Código Pagseguro 1']
                                                        else
                                                                email.link = _curso['Código Pagseguro 3']
                                                        try
                                                                email.link = email.link.split("https://pag.ae/")[1]
                                                                resolve email
                                                        catch e
                                                                reject e
                                ).bind(t:t)).then((email)->
                                        new Promise (resolve, reject) ->
                                                url = '/mailer/send/boleto?'
                                                url += "curso=#{email.curso}"
                                                url += "&to=#{email.to}"
                                                url += "&nome=#{email.nome}"
                                                url += "&link=#{email.link}"
                                                resolve url
                                #).then((url)->
                                #        Vue.http.post(url)
                                ).then(((response) ->
                                #        data = response.data
                                #        console.log data
                                        db.ref("traces/#{this.t.id}/sent_mail").set(true)
                                        toast root, {
                                                title: "Email de cobrança"
                                                msg: "" # #{data.id}\n#{data.message}",
                                                clickClose: true
                                                timeout: 200000
                                                position: "toast-top-right",
                                                type: "warning"
                                        }
                                ).bind(t:t)).then(resolve).catch((err) ->
                                        toast root, {
                                                title: err.code
                                                msg: "#{err.message}\n#{err.stack}"
                                                clickClose: true
                                                timeout: 200000
                                                position: "toast-top-right",
                                                type: "error"
                                        }
                                ))
                                
                Promise.all(promises).then(resolve).catch(reject)

# Adiciona matriculas
onMatriculas = (event) ->
        o = {}
        for e in ['input_curso', 'input_estudante' ]
                el = document.getElementById e
                k = e.split('input_fk_')[1]
                o[k] = el.value
        o.certificado = false
        o.id = uuid.v4()
        firebase.database().ref("matriculas/#{o.id}/").set o

# Adiciona Estudante
onEstudantes= (event) ->
        o = {}
        for e in ['nome', 'sobrenome', 'email1', 'email2', 'email3', 'profissao','graduacao', 'idade', 'genero', 'telefone', 'estado', 'cidade', 'isAlumni' ]
                el = document.getElementById 'input_'+e
                switch(e)
                        when 'nome' then o['Nome'] = el.value or "UNDEFINED"
                        when 'sobrenome' then o['Sobrenome'] = el.value or "UNDEFINED"
                        when 'email1' then o['Email1'] = el.value or "UNDEFINED"
                        when 'email2' then o['Email2'] = el.value or "UNDEFINED"
                        when 'email3' then o['Email3'] = el.value or "UNDEFINED"
                        when 'profissao' then o['Profissão'] = el.value or "UNDEFINED"
                        when 'graduacao' then o['Graduação'] = el.value or "UNDEFINED"
                        when 'genero' then o['Gênero'] = el.value or "UNDEFINED"
                        when 'telefone' then o['Telefone'] = el.value or "UNDEFINED"
                        when 'isAlumni' then o['Alumni(Sim_Não)'] = el.value or "UNDEFINED"
        
        o['Cidade_Estado_País'] = "#{o['cidade']}, #{o['estado']}, Brasil"
        delete o['cidade']
        delete o['estado']
        delete o['cidade']                     
        o['ID User'] = uuid.v4()
        firebase.database().ref("estudantes/#{o['ID User']}").set o
        
# Adiciona turmas
onCursos= (event) ->
        o = {}
        for e in ['nome', 'typeform_code', 'inicio_matricula','fim_matricula', 'carga_horaria','quantidade_aulas','data_inicio','data_inicio_valor1', 'data_inicio_valor2', 'data_inicio_valor3', 'valor_cheio', 'link_valor1', 'link_valor2', 'link_valor3']
                el = document.getElementById 'input_'+e
                switch(e)
                        when 'nome' then o['Nome do curso'] = el.value or "UNDEFINED"
                        when 'typeformcode' then o['Código Typeform'] = el.value or "UNDEFINED"
                        when 'inicio_matricula' then o['Início das matrículas'] = el.value or "UNDEFINED"
                        when 'fim_matricula' then o['Fim das matrículas'] = el.value or "UNDEFINED"
                        when 'carga_horaria' then o['Carga Horária'] = el.value or "UNDEFINED"
                        when 'quantidade_aulas' then o['Quantidade de Aulas'] = el.value or "UNDEFINED"
                        when 'data_inicio' then o['Data de início das aulas'] = el.value or "UNDEFINED"
                        when 'data_inicio_valor1' then o['Valor para data de início 1 (reais)'] = el.value or "UNDEFINED"
                        when 'data_inicio_valor2' then o['Valor para data de início 2 (reais)'] = el.value or "UNDEFINED"
                        when 'data_inicio_valor3' then o['Valor para data de início 3 (reais)'] = el.value or "UNDEFINED"
                        when 'valor_cheio' then o['Valor Cheio (reais)'] = el.value or "UNDEFINED"
                        when 'link_valor1' then o['Codigo Pagseguro 1'] = el.value or "UNDEFINED"
                        when 'link_valor2' then o['Codigo Pagseguro 2'] = el.value or "UNDEFINED"
                        when 'link_valor3' then o['Codigo Pagseguro 3'] = el.value or "UNDEFINED"
                        
                
        o['ID do Curso'] = uuid.v4()
                
        firebase.database().ref("cursos/#{o['ID do Curso']}").set o


# Variáveis computáveis
onComputed = (type) ->
        ->
                _type = type
                new Promise (resolve, reject) ->
                        if firebase.auth().currentUser
                                ref = _type+'/'
                                firebase.database()
                                        .ref(ref)
                                        .once('value')
                                        .then (snapshot) ->
                                                resolve snapshot.val()
                                        .catch (e) ->
                                                reject e
                        else
                                resolve()
                
# Única especificidade das variáveis computáveis
onComputedForm = ->
        new Promise (resolve, reject) ->
                if firebase.auth().currentUser
                        ref = "users/#{firebase.auth().currentUser.uid}/formularios"
                        firebase.database()
                                .ref(ref)
                                .once('value')
                                .then (snapshot) ->
                                        resolve snapshot.val()
                                .catch (e) ->
                                        reject e
                else
                        resolve()

# Editar ou atualizar campos de qq modelo
edit = (event) ->
        k = event.target.getAttribute('name')
        Vue.set this.atualizar, k, true

update = (event) ->
        k = event.target.getAttribute('name')
        f = this.$route.path.split('/')[1]
        o = {}
        i = 0

                
        for input in document.getElementsByClassName 'form-control'
                keys = input.id.split('@')
                if input.attributes.getNamedItem('type').value is 'date'
                        o[keys[1]] = input.valueAsDate
                else
                        o[keys[1]] = input.value
        self = this
        for key, val of o
                firebase.database()
                        .ref(f+'/'+k+'/'+key)
                        .set(val)

                Vue.set self[f][k], key, val

        Vue.set self.atualizar, k, false

# Quando firebase for criado ou montado
onAuthStateChanged = ->
        self = this
        firebase.auth().onAuthStateChanged (user) ->
                if user
                        self.autorizado = true
                        for e in 'displayName email photoURL telephone'.split(' ')
                                Vue.set self.user, e, self.user[e]
                                                
                        self.$router.push '/'
                else 
                        Vue.set self, 'autorizado', false
        
                
filter = (j,k) ->
        ref = k.split(j)[1]
        if ref is 'curso' or ref is 'estudante' or ref is 'matricula' then ref = ref+'s'
        if ref is  'typeform' then ref = 'formularios'
        if ref is  'typeform' then ref = 'formularios'
        return this[ref]
        
schedule = ->
        fn = ->
               
                onComputed('traces')().then (r) ->
                        console.log r
                        Vue.set(self, 'cobrancas', r)
                onComputed('estudantes')().then (r) ->
                        Vue.set(self, 'estudantes', r)
        
                onComputed('responses')().then (r) ->
                        Vue.set(self, 'responses', r)

                onComputed('formularios')().then (r) ->
                        Vue.set(self, 'formularios', r)

                onComputed('questions')().then (q) ->
                        Vue.set(self, 'questions', q)
        
                onComputed('cursos')().then (q) ->
                        Vue.set(self, 'cursos', q)
        sob.timeout(fn, 1000)
