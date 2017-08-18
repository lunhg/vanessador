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
                "formularios",
                "formularios_novo",
                "formularios_uuid_stats",
                "formularios_uuid_questions",
                "formularios_uuid_delete",
                "formularios_uuid_responses",
                "formularios_uuid_responses_token",
                "estudantes",
                "boletos",
                "boletos_id",
                "conta",
                "conta_telefone_vincular"
        ]
                log "#{e}"
                a.push Vue.http.get("/templates/#{e}") 
        Promise.all(a).then (results) ->
                props = ['autorizado', 'user']
                a = for r in results
                        r.data.component.props=props
                        r.data.props = true
                        if r.data.name is 'conta'
                                r.data.component.methods =
                                        logout: -> this.$emit('logout')
                        if r.data.name is 'estudantes'
                                r.data.component.props.push 'estudantes'
                                r.data.component.methods =
                                        importarXLS: importarXLS
                                                
                                        
                        r.data 
                Vue.use(VueRouter)
                new VueRouter
                        history: true,
                        linkActiveClass: 'active-class'
                        routes: a
                        props
               
        
