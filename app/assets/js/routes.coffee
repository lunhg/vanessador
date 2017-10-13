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
                                
                        for e in ['formularios', 'estudantes', 'cursos', 'matriculas', 'cobrancas']
                        
                                if r.data.name is e
                                        r.data.component.props.push r.data.name
                                        r.data.component.props.push "modelos"
                                        r.data.component.props.push "atualizar"

                                #console.log Vue2Autocomplete
                                r.data.component.components = 
                                        accordion: VueStrap.accordion
                                        panel: VueStrap.panel
                                
        
                                r.data.component.methods =
                                        importarXLS: importarXLS
                                        getDocumentValue: (id) -> document.getElementById(id).value
                                        edit:edit       
                                        update: update
                                        _delete: _delete

                                                
                        if r.data.name is 'matriculas'
                                r.data.component.props.push 'estudantes'
                                r.data.component.props.push 'cursos'
                                r.data.component.methods['onMatriculas']= onMatriculas
                                r.data.component.methods['filter'] =  filter
                                
                        if r.data.name is 'formularios'
                                r.data.component.props.push 'questions'
                                r.data.component.props.push 'responses'
                                r.data.component.props.push 'formularios'
                                r.data.component.props.push 'cursos'
                                r.data.component.methods['onFormularios']= onFormularios
                                r.data.component.methods['filter'] =  filter

                        if r.data.name is 'estudantes'
                                r.data.component.methods['onEstudantes']= onEstudantes

                        if r.data.name is 'cursos'
                                r.data.component.methods['onCursos']= onCursos


                        if r.data.name is 'cobrancas'
                                r.data.component.props.push 'cursos'
                                r.data.component.props.push 'estudantes'
                                r.data.component.props.push 'matriculas'
                                
                        if r.data.name is 'login'
                                r.data.component.methods =
                                        login: login

                        if r.data.name is '_index'
                                r.data.component.components = 
                                        accordion: VueStrap.accordion
                                        panel: VueStrap.panel
                r.data
                
        # return to promise 
        new VueRouter
                history: true,
                linkActiveClass: 'active-class'
                routes: a


buildRoutes = (result) ->
        a = for e in result.data
                log e
                Vue.http.get("/templates/routes/#{e}")
                
fetchRoutes = ->
        log "Loading templates..."
        Vue.http.get('/templates/index/routes')
                .then buildRoutes
                .then (results) -> Promise.all results
                .then makeRoutes
                
               
        
