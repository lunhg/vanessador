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
                "formularios",
                "importarXLS",
                "estudantes"
                "cursos"
                "matriculas"
                "boletos"
        ]
                log "#{e}"
                a.push Vue.http.get("/templates/#{e}") 
        Promise.all(a).then (results) ->
                props = ['autorizado', 'user']
                a = for r in results
                        if typeof r.data is 'object'
                                r.data.component.props=props
                                r.data.props = true
                                
                                if r.data.name is 'conta'
                                        r.data.component.methods =
                                                logout: -> this.$emit('logout')
        
                                for e in ['formularios', 'estudantes', 'cursos', 'matriculas', 'boletos']
                                        if r.data.name is e
                                                r.data.component.props.push r.data.name
                                                r.data.component.props.push "modelos"
                                                
                                                r.data.component.components = 
                                                        accordion: VueStrap.accordion
                                                        panel: VueStrap.panel
                                                        
                                                r.data.component.methods =
                                                        importarXLS: importarXLS
                                                        getDocumentValue: (id) -> document.getElementById(id).value
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
               
        
