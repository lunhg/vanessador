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
                                firebase.database().ref("responses/#{uuid}/#{r.token}").set(metdata:r.metadata,answers:r.answers,completed:if r.completed is '1' then true else false)

                        for q in result.data.questions
                                firebase.database().ref("questions/#{uuid}/#{q.id}").set(q.question)
                .then self.$options.computed.formularios


onMatriculas = (event) ->
        o = {}
        for e in ['typeform_code', 'data_inicio_valor1', 'data_inicio_valor2', 'data_inicio_valor3', 'link_valor1', 'link_valor2', 'link_valor3', 'data_inicio_matricula', 'data_fim_matricula']
                o[e] = document.getElementById('input_'+e).value

        id= document.getElementById('input_id_curso').value
        firebase.database().ref("users/#{firebase.auth().currentUser.uid}/matriculas").push(id)
        firebase.database().ref("matriculas/#{o['id_curso']}/").push o
