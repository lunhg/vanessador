# Configure o motor que alimenta os cursos,
# seus pontos de acesso, templates baixados
# do servidor e o controlador que que gerencia
# coisas como o que aparece na tela e o que
# é executado pelo firebase
fetchRoutes = ->
        log "Loading templates..."
        a = []
        for e in [
                "_index",
                "login",
                "signup",
                "resetPassword",
                "confirm",
                "conta",
                "formularios"
                "estudantes"
                "cursos"
                "turmas"
                "boletos"
                "matriculas"
        ]
                log "#{e}"
                a.push Vue.http.get("/templates/#{e}") 
        Promise.all(a).then (results) ->

                a = for r in results
                        if typeof r.data is 'object'
                                r.data.component.props= ['autorizado', 'user']
                                r.data.props = true
                                
                                if r.data.name is 'conta'
                                        r.data.component.methods =
                                                logout: -> this.$emit('logout')
        
                                for e in ['formularios', 'estudantes', 'cursos', 'turmas', 'boletos', 'matriculas']
                                        if r.data.name is e
                                                r.data.component.props.push r.data.name
                                                r.data.component.props.push "modelos"
                                                
                                                r.data.component.components = 
                                                        accordion: VueStrap.accordion
                                                        panel: VueStrap.panel
                                                        
                                                r.data.component.methods =
                                                        importarXLS: importarXLS
                                                        getDocumentValue: (id) -> document.getElementById(id).value
                                if r.data.name is 'turmas'
                                        r.data.component.methods['onTurmas']= onTurmas

                                if r.data.name is 'matriculas'
                                        r.data.component.methods['onMatriculas']= onMatriculas
                                                
                                if r.data.name is 'formularios'
                                        r.data.component.props.push 'questions'
                                        r.data.component.props.push 'responses'
                                        r.data.component.methods['onFormularios']= onFormularios
                                r.data
                        else
                                log r.data
                        
                Vue.use(VueRouter)
                new VueRouter
                        history: true,
                        linkActiveClass: 'active-class'
                        routes: a
               
        
