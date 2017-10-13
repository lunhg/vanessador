# # makeApp
# Cria uma intância Vue de acordo com um `router` definido no arquivo `app/assets/js/routes` 
makeApp = (router) ->
        Vue.use(VueRouter)
        #Vue.use(VueComputedPromise)
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
                                components:
                                        'vue-toastr': window.vueToastr
                                # Função executada quando o aplicativo Vue.js for criado
                                # Deve registrar que, quando o usuário estiver logado,
                                # as variáveis de data e computados deverão ser atualizadas
                                created: onAuthStateChanged
                        
                                # Os dados apresentados pelo Vue de acordo com o firebase,
                                # typeform e pagseguro.
                                data: ->
                                        o = results[1].data
                                        o[e] = {} for e in ['responses', 'questions', 'formularios', 'estudantes', 'cursos', 'matriculas', 'cobrancas']
                                        o
                                        
                                # # Watch (variaveis)
                                # Em caso de mudanças nas variáveis e rotas,
                                # aplique as transformações específicas
                                watch: 
                                        '$route': (to, from) ->
                                                if not this.autorizado then this.$router.push '/login'
                                                f = to.path.split('/')[1]
                                                self = this

                                                if f is 'cobrancas'
                                                        onComputed('cursos')().then (r) ->
                                                                Vue.set(self, 'cursos', r)
                                                                
                                                        onComputed('matriculas')().then (r) ->
                                                                Vue.set(self, 'matriculas', r)
                                                                        
                                                        onComputed('estudantes')().then (r) ->
                                                                Vue.set(self, 'estudantes', r)
                                                                        
                                                        onComputed('traces')().then (traces) ->
                                                                Vue.set(self, 'cobrancas', traces)
                                                                onTraces(traces, self).then ->
                                                                        
                                                else
                                                        if f is 'matriculas'
                                                                onComputed('estudantes')().then (r) ->
                                                                        Vue.set(self, 'estudantes', r)
                                                                onComputed('cursos')().then (q) ->
                                                                        Vue.set(self, 'cursos', q)

                                                                onComputed('matriculas')().then (r) ->
                                                                        Vue.set(self, 'matriculas', r)

                                                        if f is 'formularios'
                                                                onComputed('responses')().then (r) ->
                                                                        Vue.set(self, 'responses', r)
                                                                onComputed('questions')().then (q) ->
                                                                        Vue.set(self, 'questions', q)
                                                                onComputed('cursos')().then (q) ->
                                                                        Vue.set(self, 'cursos', q)
                                                                onComputed('formularios')().then (r) ->
                                                                        Vue.set(self, 'formularios', r)
                                                                
                                                        if f is 'estudantes'
                                                                onComputed('estudantes')().then (r) ->
                                                                        Vue.set(self, 'estudantes', r)
                                                        if f is 'cursos'
                                                                onComputed('cursos')().then (r) ->
                                                                        Vue.set(self, 'cursos', r)
                                # Dados computados são aqueles que serão recuperados
                                # durante uma requisição à base de dados do firebase.
                                # É importante lembrar que tais requisições são assíncronas
                                #computed:                     
                                #        cursos: onComputed('cursos')
                                #        estudantes: onComputed('estudantes')
                                #        formularios: onComputedForm
                                #        responses: onComputed('responses')
                                #        questions: onComputed('questions')
                                #        matriculas: onComputed('matriculas')
                                        
                                # Simples métodos de autorização
                                # Ver também `app/assets/js/routes.coffee`
                                methods:
                                        login: login
                                        logout: logout

