# # makeApp
# Cria uma intância Vue de acordo com um `router` definido no arquivo `app/assets/js/routes` 
makeApp = (router) ->
        Vue.use(VueRouter)
        Vue.use(VueComputedPromise)
        Promise.all([
                Vue.http.get("/templates/index/page")
                Vue.http.get("/templates/index/data")
        ]).then (results) ->
                new Promise (resolve, reject) ->
                        log results
                        resolve new Vue
                                # Roteador definido em `app/assets/js/router.coffee`
                                router: router

                                # O componente `vanessador-menu` é definido no arquivo `app/assets/js/menu`
                                # enquanto o componente `router-view` é definido no arquivo precedente
                                template: results[0].data

                                # Função executada quando o aplicativo Vue.js for criado
                                # Deve registrar que, quando o usuário estiver logado,
                                # as variáveis de data e computados deverão ser atualizadas
                                created: onAuthStateChanged
                        
                                # Os dados apresentados pelo Vue de acordo com o firebase,
                                # typeform e pagseguro.
                                data: results[1].data
                                       
                                # # Watch (variaveis)
                                # Em caso de mudanças nas variáveis e rotas,
                                # aplique as transformações específicas
                                watch: 
                                        '$route': (to, from) ->
                                                if not this.autorizado then this.$router.push '/login'
                                                console.log to
                                                f = to.path.split('/')[1]
                                                
                                                console.log f  

                                # Dados computados são aqueles que serão recuperados
                                # durante uma requisição à base de dados do firebase.
                                # É importante lembrar que tais requisições são assíncronas
                                computed:                     
                                        cursos: onComputed('cursos')
                                        estudantes: onComputed('estudantes')
                                        formularios: onComputedForm
                                        responses: onComputed('responses')
                                        questions: onComputed('questions')
                                        matriculas: onComputed('matriculas')
                                        
                                # Simples métodos de autorização
                                # Ver também `app/assets/js/routes.coffee`
                                methods:
                                        login: login
                                        logout: logout

