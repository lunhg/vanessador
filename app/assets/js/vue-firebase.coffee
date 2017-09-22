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
        onLogin = (user) -> log "user #{user.uid} logged"
                        
        onErr = (err) -> log err
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
        onSignout = -> self.$router.push '/login'
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
        query = ["/typeform/data-api?completed=true"]
        typeformcode = document.getElementById('input_typeform_code').value
        curso = document.getElementById('input_curso_code').value
        query.push "uuid=#{typeformcode}"
        query = query.join('&')
        self = this

        # Respostas são um conjunto de respostas individuais (answers)
        onResponses = (result) ->
                new Promise (resolve, reject) ->
                        for r in result.data.responses
                                firebase.database()
                                        .ref("responses/#{typeformcode}/#{r.token}")
                                        .set(metadata:r.metadata,answers:r.answers,completed:if r.completed is '1' then true else false)
              
                        resolve result
                                
        # Cada `answer` é um formulário pré-matricula.
        # Para cada formulário de pré-matricula temos um aluno
        # que deve ser verificado como dos tipos:
        #
        #   - 0 (não foi aluno e não tem direito a desconto no boleto)
        #   - 1 (foi aluno e tem direito a desconto de 25% no boleto)
        #   - 2 (caso excepcional com direito a 10% de desconto no boleto)
        onQuestions = (result) ->
                new Promise (resolve, reject) ->
                        for q in result.data.questions
                                firebase.database()
                                        .ref("questions/#{typeformcode}/#{q.id}")
                                        .set(q.question)
                        resolve result
                
        onRegisterForm = (result) ->
                new Promise (resolve, reject) ->
                        firebase.database()
                                .ref("formularios/")
                                .push(typeformcode)
                                .then -> resolve result

        # Registra uma Matricula
        # com o status de não matriculado, e não certificado
        # com o nome correspondente à matrícula do curso referido
        # no campo ID curso para cada resposta, que será relacionada
        # à um novo estudante
        onGetName = (result) ->
                console.log result.data
                o = {}
                for r in result.data.responses
                        for q, question of result.data.questions
                                if o[question.question] is undefined
                                        o[question.question] = r.answers[question.id]
                o

        onCheckEstudante = (result) ->
                addNovoEstudante = ->
                        console.log "Não existe estudante com esse nome"
                        console.log "Criando um novo estudante"
                        result['ID User'] = uuid.v4()
                        result['Alumni(Sim_Não)'] = "Não"
                        result['Cidade_Estado_País'] = "UNDEFINED"
                        result['Email 1'] = result['Email']
                        delete result['Email']
                        result['Email 2'] = "UNDEFINED"
                        result['Email 3'] = "UNDEFINED"
                        result['Gênero'] = "UNDEFINED"
                        result['Telefone'] = "UNDEFINED"
                        result['Graduação'] = result['Escolaridade']
                        delete result['Escolaridade']
                        delete result['Já realizou algum curso ITS Anteriormente?']
                        delete result['Se sim, qual?']
                        console.log result
                        firebase.database()
                                .ref("estudantes/#{result['ID User']}")
                                .set(result)
                        
                # Checar se existe o estudante
                firebase.database().ref('estudantes/').once 'value', (snapshot) ->
                        console.log result
                        if snapshot.val() isnt null
                                for e, est of snapshot.val()
                                        __uid__ = uuid.v4()
                                        # Estudante existe
                                        if est['Nome'] is result['Nome'] 
                                                console.log est
                                                # É alumni?
                                                if est['Alumni(Sim_Não)']
                                                        console.log est
                                                # Não é alumni
                                                else
                                                        console.log est
                                        # Não existe estudante
                                        else
                                                addNovoEstudante()
                        else
                                addNovoEstudante()
                result
                
                                              
        onNovaMatricula = (result) ->
                __uid__ = uuid.v4()
                firebase.database().ref("cursos/#{curso}").once 'value', (snapshot) ->
                        
                firebase.database().ref("matriculas/#{__uid__}").set({
                        curso: curso
                        estudante: result['ID User']
                        boleto:
                                status: 'Pendente'
                                desconto
                        
                })
        # * Capture o typeform
        # * popule as respostas (verificando a existência desse aluno no
        #   firebase, dando-lhe uma verificação `isAlumini={0 or 1 or 2}` para cada `answer` )
        # * e registre uma chave para cada formulario
        this.$http.get(query)
                .then onRegisterForm
                .then onQuestions
                .then onResponses
                .then onGetName
                .then onCheckEstudante
                .then onNovaMatricula


# Adiciona matriculas
onMatriculas = (event) ->
        o = {}
        for e in ['input_fk_curso', 'input_fk_estudante' ]
                el = document.getElementById e
                k = e.split('input_fk_')[1]
                o[k] = el.value
        o.certificado = false
        o.id = uuid.v4()
        firebase.database().ref("matriculas/#{o.id}/").set o

# Adiciona turmas
onTurmas= (event) ->
        o = {}
        for e in ['id_curso', 'typeform_code', 'codigo_valor1', 'codigo_valor2', 'codigo_valor3' ]
                el = document.getElementById 'input_'+e
                o[e] = el.value
                
        firebase.database().ref("turmas/").push o

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
                else
                        Vue.set self, 'autorizado', false

onSearch = (event) ->
        self = this
        Vue.nextTick ->
                 item = document.getElementById('search-input').value.split(" ").join("/")
                 console.log "Searching for #{item}"
                 firebase.database().ref(item).once 'value', (snapshot) ->
                         document.getElementsByClassName('list-group-item').classList.remove('hide')
                         console.log snapshot.val()
