AppManager::templates = ->

        getTemplate = (p) ->
                new Promise (resolve, reject) ->
                        _p = path.resolve "#{path.join(__dirname)}/../app/views/#{p}.pug"
                        fs.readFile _p, 'utf8', (err, content) ->
                                if not err
                                        try
                                                opt = {filename: _p, doctype:'html'}
                                                html = pug.compile(content, opt)()
                                                result = component: {template: html}, name: p
                                                if p.match /_index/
                                                        result.path = "/"
                                                # GET /#/formularios/:uuid/stats
                                                # GET /#/formularios/:uuid/questions
                                                # GET /#/formularios/:uuid/responses
                                                else if p.match /^formularios_uuid_[a-z]+$/
                                                        r = p.split("_")
                                                        result.path = "/#{r[0]}/:uuid/#{r[2]}"

                                                # GET /#/formularios/:uuid/responses/:token
                                                else if p.match /^formularios_uuid_\w+_[a-z]+$/
                                                        r = p.split("_")
                                                        result.path = "/#{r[0]}/:uuid/#{r[2]}/:token"

                                                # GET /#/formularios/novo
                                                else if p.match /formularios_novo/
                                                        r = p.split("_")
                                                        result.path = "/#{r[0]}/novo"
        
                                                # GET /#/boletos/:invoiceid
                                                else if p.match /^boletos$/
                                                        result.path = "/boletos"
                        
                                                # GET /#/boletos/:invoiceid
                                                else if p.match /boletos_id/
                                                        r = p.split("_")
                                                        result.path = "/boletos/:invoiceid"

                                                # GET /#/conta/telefone/vincular
                                                else if p.match /^conta_\w+_\w+$/
                                                        r = p.split("_")
                                                        result.path = "/#{r[0]}/:option/:action"

                                                # GET /#/estudantes
                                                else if p.match /^estudantes$/
                                                        result.path = "/estudantes"
                                                        
                                                # GET /#/estudantes/:id
                                                else if p.match /^estudantes_id$/
                                                        result.path = "/estudantes/:id"

                                                # GET /#/cursos
                                                else if p.match /^cursos$/
                                                        result.path = "/cursos"
                                                        
                                                # GET /#/estudantes/:id
                                                else if p.match /^cursos_id$/
                                                        result.path = "/cursos/:id"
                                                        
                                                else 
                                                        result.path = "/#{p}"
                                                        
                                                resolve result
                                        catch e
                                                console.log e
                                                reject e
                                else
                                        reject err

                
        @app.get '/templates/routes/:type', (req, res) ->
                onSuccess = (result) -> res.json result
                onErr = (err) -> res.json err.message
                getTemplate(req.params['type']).then(onSuccess).catch(onErr)

        @app.get '/templates/index/routes', (req, res) ->
                res.json [
                        "_index",
                        "login",
                        "signup",
                        "resetPassword",
                        "confirm",
                        "conta",
                        "formularios"
                        "estudantes"
                        "cursos"
                        "matriculas"
                        "cobrancas"
                ]
                
        @app.get "/templates/index/page", (req, res) ->
                p = path.join(__dirname, '..', 'app/views', 'vue.pug')
                fs.readFile p, 'utf8', (err, content) ->
                        opt = {filename: p, doctype:'html'}
                        html = pug.compile(content, opt)()
                        res.send html

        @app.get "/templates/index/data", (req, res) ->
                xlsCursos =
                        input_list: {'type':'text', 'placeholder':'ABCDEFG', 'label': 'Colunas'}
                        input_min: {'type':'text', 'placeholder':'2', 'label': 'Linha inicial'}
                        input_max: {'type':'text', 'placeholder':'26', 'label': 'Linha final'}
                xlsEstudantes =
                        input_list: {'type':'text', 'placeholder':'ABCDEFGHIJKLMNO', 'label': 'Colunas'}
                        input_min: {'type':'text', 'placeholder':'2', 'label': 'Linha inicial'}
                        input_max: {'type':'text', 'placeholder':'726', 'label': 'Linha final'}
                xlsFormularios =
                        input_list: {'type':'text', 'placeholder':'AB', 'label': 'Colunas'}
                        input_min: {'type':'text', 'placeholder':'2', 'label': 'Linha inicial'}
                        input_max: {'type':'text', 'placeholder':'3', 'label': 'Linha final'}

                xlsMatriculas =
                        input_list: {'type':'text', 'placeholder':'AB', 'label': 'Colunas'}
                        input_min: {'type':'text', 'placeholder':'2', 'label': 'Linha inicial'}
                        input_max: {'type':'text', 'placeholder':'3', 'label': 'Linha final'}

                formularios =
                        input_typeform: {'type':'text', 'placeholder':'E20qGg', 'label': 'Código typeform'}
                        input_curso: {'type':'text', 'placeholder':'-Ktm1CBbiRXF7OEUellX', 'label': 'ID curso'}

                matriculas =
                        input_curso: {'type':'text', 'label':'ID curso'}
                        input_estudante: {'type':'text', 'label':'ID estudante'}

                estudantes =
                        input_nome: {'type':'text', 'placeholder':'nome', 'label': 'Nome'}
                        input_sobrenome: {'type':'text', 'placeholder':'sobrenome', 'label': 'Sobrenome'}
                        input_email1: {'type':'text', 'placeholder':'email1@dominio', 'label': 'Email 1'}
                        input_email2: {'type':'text', 'placeholder':'email2@dominio', 'label': 'Email 2'}
                        input_email3: {'type':'text', 'placeholder':'email3@dominio', 'label': 'Email 3'}
                        input_profissao: {'type':'text', 'placeholder':'trabalho', 'label': 'Profissão'}
                        input_graduacao: {'type':'text', 'placeholder':'graduação', 'label': 'Graduação'}
                        input_idade: {'type':'text', 'placeholder':'8-80', 'label': 'Idade'}
                        input_genero: {'type':'text', 'placeholder':'M/F/Outro', 'label': 'Gênero'}
                        input_telefone: {'type':'text', 'placeholder':'12345678', 'label': 'Telefone'}
                        input_estado: {'type':'text', 'placeholder':'propriedade', 'label': 'Estado'}
                        input_cidade: {'type':'text', 'placeholder':'propriedade', 'label': 'Cidade'}
                        input_isAlumni: {'type':'check', 'label': 'É Alumni?'}

                cursos =
                        input_nome: {'type':'text', 'placeholder':'nome', 'label': 'Nome'}
                        input_inicio_matricula: {'type':'date', 'label': 'Início das matrículas'}
                        input_fim_matricula: {'type':'date', 'label': 'Fim das matrículas'}
                        input_carga_horaria: {'type':'text', 'placeholder':'6 hs', 'label': 'Carga Horária'}
                        input_quantidade_aulas: {'type':'number', 'placeholder':'3', 'label': 'Quantidade de Aulas'}
                        input_data_inicio: {'type':'date', 'label': 'Data de início das aulas'}
                        input_data_termino: {'type':'date', 'label': 'Data de término das aulas'}
                        input_data_inicio_valor1: {'type':'number', 'label': 'Valor para data de início 1 (reais)'}
                        input_data_inicio_valor2: {'type':'number', 'label': 'Valor para data de início 2 (reais)'}
                        input_data_inicio_valor3: {'type':'number', 'label': 'Valor para data de início 3 (reais)'}
                        input_valor_cheio: {'type':'number', 'placeholder':'200', 'label': 'Valor Cheio (reais)'}
                        input_link_valor1: {'type':'text', 'placeholder': 'https://pag.ae/12345', 'label': 'Codigo Pagseguro 1'}
                        input_link_valor2: {'type':'text', 'placeholder': 'https://pag.ae/45678', 'label': 'Codigo Pagseguro 2'}
                        input_link_valor3: {'type':'text', 'placeholder': 'https://pag.ae/90123', 'label': 'Codigo Pagseguro 3'}
                res.json {
                        search:''
                        autorizado:false
                        user:
                                displayName:false
                                email:false
                                photoURL:false
                                telephone:false
                        atualizar: {}
                        modelos:
                                xls:
                                        cursos: xlsCursos
                                        estudantes: xlsEstudantes
                                        formularios: xlsFormularios
                                        matriculas: xlsMatriculas
                                        
                                formularios: formularios
                                matriculas: matriculas        
                                estudantes:estudantes
                                cursos:cursos
                }
                                
