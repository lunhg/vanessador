emailRE = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        
validation = -> {
        name:!!@user.name.trim()
        email:emailRE.test(@user.name)
}

isValid = ->
        val = @validation
        Object.keys(val).every (key) -> val[key]

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

logout = ->
        self = this
        onSignout = -> self.$router.push '/login'
        firebase.auth().signOut().then(onSignout).catch(AuthService.onErr)
        
addUser = ->
        if @isValid
                firebase.database().ref('users').push @user
                @user.name = ''
                @user.email = ''
                @user.tel = ''
                
removeUser = (user) -> firebase.database().ref('users').child(user['.key']).remove()

onFormularios = (event) ->
        query = ["/typeform/data-api?completed=true"]
        uuid = document.getElementById('input_typeform_code').value
        query.push "uuid=#{uuid}"
        query = query.join('&')
        self = this
        this.$http.get(query)
                .then (result) ->
                        firebase.database().ref("users/#{firebase.auth().currentUser.uid}/formularios").push(uuid)
                        for r in result.data.responses
                                firebase.database()
                                        .ref("responses/#{uuid}/#{r.token}")
                                        .set(metdata:r.metadata,answers:r.answers,completed:if r.completed is '1' then true else false)

                        for q in result.data.questions
                                firebase.database()
                                        .ref("questions/#{uuid}/#{q.id}")
                                        .set(q.question)

                        db = firebase.database()
                        ref1 = "users/#{}/formularios"
                        firebase.database().ref(ref1).once 'value', (f) ->
                                resolve f.val()
                .then 
                .then self.$options.computed.formularios


onTurmas = (event) ->
        o = {}
        for e in ['input_id_curso', 'typeform_code', 'data_inicio_valor1', 'data_inicio_valor2', 'data_inicio_valor3', 'link_valor1', 'link_valor2', 'link_valor3', 'inicio_matricula', 'fim_matricula']
                el = document.getElementById 'input_'+e
                o[e] = el.value
                

        firebase.database().ref("users/#{firebase.auth().currentUser.uid}/turmas").push(o['input_id_curso'])
        firebase.database().ref("turmas/#{id}/").push o

onMatriculas = (event) ->
        o = {}
        for e in ['input_fk_turma', 'input_fk_estudante', 'input_matriculado', 'input_certificado' ]
                el = document.getElementById 'input_'+e
                o[e] = el.value
                

        firebase.database().ref("users/#{firebase.auth().currentUser.uid}/matriculas").push(o['input_fk_turma'])
        firebase.database().ref("matriculas/#{id}/").push o
