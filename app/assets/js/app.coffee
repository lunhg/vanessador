# # makeApp
# Cria uma intância Vue de acordo com um `router` definido no arquivo `app/assets/js/routes` 
makeApp = (router) ->
        new Vue {
                router: router

                # O componente `vanessador-menu` é definido no arquivo `app/assets/js/menu`
                # enquanto o componente `router-view` é definido no arquivo precedente
                template: "<div><vanessador-menu :autorizado='autorizado' :user='user'></vanessador-menu><router-view :autorizado='autorizado' :user='user' :estudantes='estudantes'></router-view></div>"

                # Quando o aplicativo Vue for criado,
                # configure o firebase e verifique se
                # existe um usuário logado. Em caso positivo,
                # redirecione para o home. Em caso negativo,
                # redirecione para o login.
                created: ->
                        self = this
                        fetchConfig().then (config) ->
                                if firebase.apps.length is 0
                                        firebase.initializeApp(config.data)
                                firebase.auth().onAuthStateChanged (user) ->
                                        if user
                                                self.autorizado = true
                                                self.user[e] = user[e] for e in 'displayName email photoURL telephone'.split(' ')
                                                        
                                                self.$router.push '/'
                                        else
                                                self.$router.push '/login'
                        console.log self

                # Os dados apresentados pelo Vue de acordo com o firebase,
                # typeform e pagseguro.
                data:
                        autorizado:false
                        user:
                                displayName: false
                                email:false
                                photoURL:false
                                telephone:false
                        estudantes:false
                        formularios:false
                        questoes:false
                        respostas:false
                        boletos:false

                # Em caso de mudanças nas variáveis e rotas,
                # aplique as transformações específicas
                watch:
                        '$route': (to, from) ->
                                self = this

                                # Cada vez que formos para rota estudantes
                                # atualize os dados do firebase
                                if to.path is '/estudantes'
                                        firebase.database().ref('estudantes/').once 'value', (snapshot) ->
                                                self.estudantes = snapshot.val()
                        user: ->
                                this.$data.autorizado = true

                # Métodos gerais
                methods:
                        login: login
                        logout: logout
                                
        }
        
# A mensagem de carregamento inicial
# deve ser atualizada
loader = document.getElementById('masterLoader')

log = (msg) ->
        p = loader.children[9]
        console.log msg
        # Give to main page a percept of fluxus
        setTimeout ->
                p.innerHTML = msg
        , 500
