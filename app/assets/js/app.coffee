# # makeApp
# Cria uma intância Vue de acordo com um `router` definido no arquivo `app/assets/js/routes` 
makeApp = (router) ->
        Vue.use(VueComputedPromise);
        new Vue {
                # Roteador definido em `app/assets/js/router.coffee`
                router: router

                # O componente `vanessador-menu` é definido no arquivo `app/assets/js/menu`
                # enquanto o componente `router-view` é definido no arquivo precedente
                template: """<div>
  <vanessador-menu :autorizado='autorizado' :user='user'></vanessador-menu>
  <div class='container-fluid'>
    <div class='side-body'>
      <router-view :autorizado='autorizado' :user='user' :estudantes='estudantes' :cursos='cursos' :formularios='formularios' :boletos='boletos' :modelos='modelos' :questions='questions' :responses='responses'></router-view>
    </div>
  </div>
</div>"""

                # Função executada quando o aplicativo Vue.js for criado.
                beforeCreate: ->
                        self = this
                        firebase.auth().onAuthStateChanged (user) ->
                                if user
                                        
                                        self.autorizado = true
                                        self.user[e] = user[e] for e in 'displayName email photoURL telephone'.split(' ')
                        
                # Os dados apresentados pelo Vue de acordo com o firebase,
                # typeform e pagseguro.
                data:
                        search:''
                        autorizado:false
                        user:
                                displayName: false
                                email:false
                                photoURL:false
                                telephone:false
                        modelos:
                                xls:
                                        cursos:
                                                input_list: {'type':'text', 'placeholder':'ABCDEFG', 'label': 'Colunas'},
                                                input_min: {'type':'text', 'placeholder':'2', 'label': 'Linha inicial'},
                                                input_max: {'type':'text', 'placeholder':'26', 'label': 'Linha final'}
                                        estudantes:
                                                input_list: {'type':'text', 'placeholder':'ABCDEFGHIJKLMNO', 'label': 'Colunas'},
                                                input_min: {'type':'text', 'placeholder':'2', 'label': 'Linha inicial'},
                                                input_max: {'type':'text', 'placeholder':'726', 'label': 'Linha final'}

                                        turmas:
                                                input_list: {'type':'text', 'placeholder':'ABCDE', 'label': 'Colunas'},
                                                input_min: {'type':'text', 'placeholder':'2', 'label': 'Linha inicial'},
                                                input_max: {'type':'text', 'placeholder':'749', 'label': 'Linha final'}

                                        formularios:
                                                input_list: {'type':'text', 'placeholder':'AB', 'label': 'Colunas'},
                                                input_min: {'type':'text', 'placeholder':'2', 'label': 'Linha inicial'},
                                                input_max: {'type':'text', 'placeholder':'3', 'label': 'Linha final'}
                                        boletos:
                                                input_list: {'type':'text', 'placeholder':'AB', 'label': 'Colunas'},
                                                input_min: {'type':'text', 'placeholder':'2', 'label': 'Linha inicial'},
                                                input_max: {'type':'text', 'placeholder':'3', 'label': 'Linha final'}
                                        matriculas:
                                                input_list: {'type':'text', 'placeholder':'AB', 'label': 'Colunas'},
                                                input_min: {'type':'text', 'placeholder':'2', 'label': 'Linha inicial'},
                                                input_max: {'type':'text', 'placeholder':'3', 'label': 'Linha final'}


                                estudantes:
                                        input_nome: {'type':'text', 'placeholder':'nome', 'label': 'Nome'},
                                        input_email1: {'type':'text', 'placeholder':'email1@dominio', 'label': 'Email 1'},
                                        input_email2: {'type':'text', 'placeholder':'email2@dominio', 'label': 'Email 2'},
                                        input_email3: {'type':'text', 'placeholder':'email3@dominio', 'label': 'Email 3'},
                                        input_profissao: {'type':'text', 'placeholder':'trabalho', 'label': 'Profissão'},
                                        input_idade: {'type':'text', 'placeholder':'8-80', 'label': 'Idade'}
                                        input_genero: {'type':'text', 'placeholder':'M/F/Outro', 'label': 'Gênero'}
                                        input_telefone: {'type':'text', 'placeholder':'12345678', 'label': 'Telefone'}
                                        input_estado: {'type':'text', 'placeholder':'propriedade', 'label': 'Propriedade'}
                                        input_isAlumni: {'type':'check', 'label': 'Idade'}

                                cursos:
                                        input_nome: {'type':'text', 'placeholder':'nome', 'label': 'Nome'}
                                        input_carga_horaria: {'type':'text', 'placeholder':'6 hs', 'label': 'Carga Horária'}
                                        input_quantidade_aulas: {'type':'text', 'placeholder':'3', 'label': 'Quantidade de Aulas'}
                                        input_valor_cheio: {'type':'text', 'placeholder':'200', 'label': 'Valor Cheio (R$)'}
                                        input_data_inicio: {'type':'date', 'label': 'Data de início'}
                                        input_data_termino: {'type':'date', 'label': 'Data de término'}

                                turmas:
                                        input_id_curso: {'type':'text', 'placeholder':'84fgba23...', 'label': 'ID do curso'}
                                        input_typeform_code: {'type':'text', 'placeholder':'JZavQ', 'label': 'Código typeform'}
                                        input_data_inicio_valor1: {'type':'date', 'label': 'Data de início 1'}
                                        input_data_inicio_valor2: {'type':'date', 'label': 'Data de início 2'}

                                        input_data_inicio_valor3: {'type':'date', 'label': 'Data de início 3'}
                                        input_link_valor1: {'type':'number', 'placeholder': '200', 'label': 'Valor 1'},
                                        input_link_valor2: {'type':'number', 'placeholder': '200', 'label': 'Valor 2'},
                                        input_link_valor3: {'type':'number', 'placeholder': '200', 'label': 'Valor 3'},

                                        input_inicio_matricula: {'type':'date', 'label': 'Data de início de matrícula'}
                                        input_fim_matricula: {'type':'date', 'label': 'Data de término de matrícula'}

                                formularios:
                                        input_typeform_code: {'type':'text', 'placeholder':'JZavQC', 'label': 'Código typeform'}

                                matriculas:
                                        input_fk_turma: {'type':'text', 'label':'ID turma'}
                                        input_fk_estudante: {'type':'text', 'label':'ID estudante'}
                                        input_matriculado: {'type':'checkbox', 'label':'Matriculado?'}
                                        input_certificado: {'type':'checkbox', 'label':'Certificado?'}
                                        
                                        
                # # Watch (variaveis)
                # Em caso de mudanças nas variáveis e rotas,
                # aplique as transformações específicas
                watch: 

                        '$route': (to, from) -> if not this.autorizado then this.$router.push '/login'         
                        user: ->
                                this.$data.autorizado = true
                                if from.path is '/login' and this.$data.autorizado is true then this.$router.push '/'

                computed:
                        cursos: ->
                                new Promise (resolve, reject) ->
                                        firebase.database().ref('cursos/').once 'value', (snapshot) ->
                                                resolve snapshot.val()
                                        
                        estudantes: ->
                                new Promise (resolve, reject) ->
                                        firebase.database().ref('estudantes/').once 'value', (snapshot) ->
                                                resolve snapshot.val()

                        formularios: ->
                                new Promise (resolve, reject) ->
                                        Vue.nextTick ->
                                                if firebase.auth().currentUser.uid
                                                        db = firebase.database()
                                                        currentUser = firebase.auth().currentUser
                                                        ref1 = "users/#{currentUser.uuid}/formularios"
                                                        db.ref(ref1).on 'value', (f) ->
                                                                resolve f.val()
                                                else
                                                        resolve false
                        responses: ->
                                new Promise (resolve, reject) ->
                                        Vue.nextTick ->
                                                ref1 = "responses/"
                                                firebase.database().ref(ref1).once 'value', (r) ->
                                                        resolve r.val()
                        turmas: ->
                                new Promise (resolve, reject) ->
                                        firebase.database().ref('turmas/').once 'value', (snapshot) ->
                                                resolve snapshot.val()

                        boletos: ->
                                new Promise (resolve, reject) ->
                                        firebase.database().ref('boletos/').once 'value', (snapshot) ->
                                                resolve snapshot.val()

                        questions: ->
                                new Promise (resolve, reject) ->
                                        Vue.nextTick ->
                                                ref1 = "questions/"
                                                firebase.database().ref(ref1).once 'value', (q) ->
                                                        resolve q.val()
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
        fluxus = -> p.innerHTML = msg
        setTimeout fluxus, 750
