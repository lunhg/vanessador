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
        uuid = document.getElementById('input_typeform_code').value
        turma = document.getElementById('input_turma_code').value
        pagseguro_code = document.getElementById('input_pagseguro_code').value
        query.push "uuid=#{uuid}"
        query = query.join('&')
        self = this

        # Respostas são um conjunto de respostas individuais (answers)
        onResponses = (result) ->
                new Promise (resolve, reject) ->
                        for r in result.data.responses
                                firebase.database()
                                        .ref("responses/#{uuid}/#{r.token}")
                                        .set(metdata:r.metadata,answers:r.answers,completed:if r.completed is '1' then true else false).then onGeraBoleto(r)              
              
                        resolve result
                                
        # Cada `answer` é um formulário pré-matricula.
        # Para cada formulário de pré-matricula temos um aluno
        # que deve ser verificado como dos tipos:
        #
        #   - 0 (não foi aluno e não tem direito a desconto no boleto)
        #   - 1 (foi aluno e tem direito a desconto de 25% no boleto)
        #   - 2 (caso excepcional com direito a 10% de desconto no boleto)
        onAnswers = (result) ->
                new Promise (resolve, reject) ->
                        for q in result.data.questions
                                firebase.database()
                                        .ref("questions/#{uuid}/#{q.id}")
                                        .set(q.question)
                        resolve result
                
        onRegisterForm = (result) ->
                new Promise (resolve, reject) ->
                        firebase.database()
                                .ref("formularios/")
                                .push(uuid)
                                .then ->
                                        resolve result
        onCheckAnswers = (result) ->
                new Promise (resolve, reject) ->
                        db = firebase.database()
                        estudantes = {}
                        answers = {}
                        questions = {}
                        db.ref("estudantes/").once 'value', (snapshot) ->
                                estudantes[k] = estudante for k,estudante of snapshot.val()
                        db.ref("questions/#{uuid}").once 'value', (snapshot) ->
                                questions[k] = question for k,question of snapshot.val()

                        db.ref("responses/#{uuid}").once 'value', (snapshot) ->
                                for q,question of questions
                                        for k,answer of snapshot.val()
                                                if k is q
                                                        answers[question] = answer
                                        
                        console.log answers

        # * Capture o typeform
        # * popule as respostas (verificando a existência desse aluno no
        #   firebase, dando-lhe uma verificação `isAlumini={0 or 1 or 2}` para cada `answer` )
        # * e registre uma chave para cada formulario
        this.$http.get(query)
                .then onResponses
                .then onAnswers
                .then onRegisterForm
                .then self.$options.computed.formularios


# Adiciona matriculas
onMatriculas = (event) ->
        o = {}
        for e in ['input_fk_turma', 'input_fk_estudante', 'input_matriculado', 'input_certificado' ]
                el = document.getElementById e
                o[e] = el.value
                
        firebase.database().ref("matriculas/#{id}/").push o

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
