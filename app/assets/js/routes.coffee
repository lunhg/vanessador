# Configure o motor que alimenta os cursos,
# seus pontos de acesso, templates baixados
# do servidor e o controlador que que gerencia
# coisas como o que aparece na tela e o que
# é executado pelo firebase
makeRoutes = (results) ->
        a = for r in results
                if typeof r.data is 'object'
                        r.data.component.props= ['autorizado', 'user']
                        r.data.props = true
                        
                                
                if r.data.name is 'conta'
                        r.data.component.methods =
                                logout: -> this.$emit('logout')
        
                for e in ['formularios', 'estudantes', 'cursos', 'matriculas']
                        
                        if r.data.name is e
                                r.data.component.props.push r.data.name
                                r.data.component.props.push "modelos"
                                r.data.component.props.push "atualizar"
                                                
                        r.data.component.components = 
                                accordion: VueStrap.accordion
                                panel: VueStrap.panel
        
                        r.data.component.methods =
                                importarXLS: importarXLS
                                getDocumentValue: (id) -> document.getElementById(id).value
                                edit:edit       
                                update: update
                                                                
                if r.data.name is 'matriculas'
                        r.data.component.methods['onMatriculas']= onMatriculas
                                        
                if r.data.name is 'formularios'
                        r.data.component.props.push 'questions'
                        r.data.component.props.push 'responses'
                        r.data.component.methods['onFormularios']= onFormularios
                r.data
                
        # return to promise 
        new VueRouter
                history: true,
                linkActiveClass: 'active-class'
                routes: a


buildRoutes = (result) -> a = Vue.http.get("/templates/routes/#{e}") for e in result.data
        
fetchRoutes = ->
        log "Loading templates..."
        Vue.http.get('/templates/index/routes')
                .then buildRoutes
                .then (results) -> Promise.all results
                .then makeRoutes
                
               
        
