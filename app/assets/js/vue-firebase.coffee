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
                log err
                toast self.$parent, 'error', {
                        title: "Error",
                        msg: err.message
                        clickClose: true
                        timeout: 5000
                        position: "toast-top-right",
                        type: "warning"
                }
        email = document.getElementById(id_login).value
        if email.match(emailRE)
                firebase.auth()
                        .signInWithEmailAndPassword(email,(document.getElementById(id_password).value))
                        .then(onLogin)
                        .catch(onErr)
        else
                log new Error("Email not allowed")
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
        firebase.auth().signOut().then(onSignout).catch (e) -> console.log e

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
                                .then(-> resolve(result))
                                .catch(reject)

                                
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
                                .then(-> resolve(result))
                                .catch(reject)
                        
        # Registra formulario simples
        onRegisterForm = (result) ->
                new Promise (resolve, reject) ->
                        firebase.database()
                                .ref("formularios/#{typeformcode}")
                                .set(curso: curso)
                                .then -> resolve result

        # Registra uma Matricula
        # com o status de não matriculado, e não certificado
        # com o nome correspondente à matrícula do curso referido
        # no campo ID curso para cada resposta, que será relacionada
        # à um novo estudante
        onGetEstudantesInfo = (result) ->
                estudantes = []
                for r in result.data.responses
                        estudante = null
                        for q, question of result.data.questions
                                if estudante is null then estudante = {}
                                if estudante[question.question] is undefined
                                        estudante[question.question] = r.answers[question.id]
                                        
                        estudantes.push estudante
                estudantes
                   
        # Checar se existe o estudante
        # se existir, já está configurado o Alumni
        # se não existir, não tem alumni configurado
        # e necessita da criação de um novo registro de estudante
        onSetEstudantes = (estudantes) ->
                self = this
                new Promise (resolve, reject) ->
                        __estudantes__ = []
                        onAdd = (w) ->
                                estudante = {}
                                for e in ['Cidade_Estado_País',
                                        'Email2',
                                        'Email3',
                                        'Gênero',
                                        'Telefone']
                                        estudante[e] = 'UNDEFINED' 
                                        estudante['ID User'] = uuid.v4()
                                estudante['Alumni(Sim_Não)'] = "Não"
                                estudante['Nome'] = w['Nome']
                                estudante['Sobrenome'] = w['Sobrenome']
                                estudante['Email1'] = w['Email']
                                estudante['Idade'] = w['Idade']
                                estudante['Profissão'] = w['Profissão']
                                estudante['Graduação'] = w['Escolaridade']
                                __estudantes__.push estudante
                                
                        onVal = (snapshot) ->
                                for k, e in snapshot.val()
                                        for q, w of estudantes
                                                # É Alumni
                                                if w['Nome'] is e['Nome'] and w['Sobrenome'] is e['Sobrenome']
                                                        __estudantes__.push est
                                                # Não é alumni
                                                else
                                                        onAdd(w)
                                                        db.ref("estudantes/#{e['ID User']}").set(e) for e in __estudantes__
                                resolve(__estudantes__)
                                                        
                        db.ref("estudantes/").once('value').then(onVal).catch (e) ->
                                # No caso de nenhum estudante existir
                                onAdd(w) for w in estudantes
                                db.ref("estudantes/#{e['ID User']}").set(e) for e in __estudantes__
                                resolve(__estudantes__)
                                
                
        # Para cada estudante checado e/ou criado, crie uma nova matrícula
        # com um curso em comum (turma)
        onNovasMatriculas = (estudantes) ->
                new Promise (resolve, reject) ->
                        promises = []
                        matriculas = []
                        firebase.database().ref("cursos/#{curso}").once 'value', (snapshot) ->
                                id = snapshot.val()['ID do Curso']
                                nome = snapshot.val()['Nome do curso']
                                c1 = snapshot.val()['Código Pagseguro 1']
                                c2 = snapshot.val()['Código Pagseguro 2']
                                c3 = snapshot.val()['Código Pagseguro 3']
                                for e in estudantes
                                        newid = uuid.v4()

                                        # MUITO IMPORTANTE
                                        # Checagem de ex-estudante,
                                        # - Se a Flag Alumni(Sim_Não) for Sim: link 1
                                        # - Se a Flag Alumni(Sim_Não) for Não: link 3
                                        if e['Alumni(Sim_Não)'] is "Sim"
                                                link = c1
                                        else
                                                link = c3
                                        promises.push firebase.database().ref("matriculas/#{newid}").set({
                                                link: link
                                                curso: curso
                                                estudante:e['ID User']
                                                pago: false
                                        }).then onSendBoleto({
                                                        curso: nome
                                                        to: e['Email1']
                                                        nome: e['Nome'] + " " +e['Sobrenome']
                                                        link: link.split("https://pag.ae/")[1]
                                                })
                                Promise.all(promises).then(resolve).catch reject
                

        # Envia o boleto via email
        onSendBoleto = (result) ->
                new Promise (resolve, reject) ->
                        url = '/mailer/send/boleto?'
                        url += "curso=#{result.curso}"
                        url += "&to=#{result.to}"
                        url += "&nome=#{result.nome}"
                        url += "&link=#{result.link}"
                        Vue.http.post(url)
                                .then (data) ->
                                        console.log data.body
                                        resolve()
                                .catch reject
        # * Capture o typeform
        # * popule as respostas (verificando a existência desse aluno no
        #   firebase, dando-lhe uma verificação `isAlumini={0 or 1 or 2}` para cada `answer` )
        # * e registre uma chave para cada formulario
        this.$http.get(query)
                .then onRegisterForm
                .then onQuestions
                .then onResponses
                .then onGetEstudantesInfo
                .then onSetEstudantes
                .then onNovasMatriculas

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
                                console.log ref
                                firebase.database()
                                        .ref(ref)
                                        .once('value')
                                        .then (snapshot) ->
                                                console.log snapshot.val()
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
                        for e in ['formularios', 'responses', 'questions', 'estudantes', 'cursos', 'matriculas']
                                _e = e
                                firebase.database().ref(e+'/').once 'value', (snapshot) ->
                                        
                                        Vue.set self, _e, snapshot.val()

                        self.$router.push '/'
                else 
                        Vue.set self, 'autorizado', false
        
                
filter = (j,k) ->
        ref = k.split(j)[1]
        console.log ref
        if ref is 'curso' or ref is 'estudante' or ref is 'matricula' then ref = ref+'s'
        if ref is  'typeform' then ref = 'formularios'
        if ref is  'typeform' then ref = 'formularios'
        return this[ref]
        
