# Configure o motor que alimenta os cursos,
# seus pontos de acesso, templates baixados
# do servidor e o controlador que que gerencia
# coisas como o que aparece na tela e o que
# é executado pelo firebase
fetchMenu = (config) ->
        log "Loading Menu"
        Vue.http.get("/templates/menu").then (result) ->
                Vue.component 'vanessador-menu',
                        props: ['autorizado', 'user']
                        template: result.data.component.template
                        data: ->
                                {
                                        active: conta: false
                                }
                        methods:
                                login: -> this.$emit 'login'
                                logout: -> this.$emit 'logout'
                                toogle: (w) ->
                                        if w is 'conta'
                                                if this.active[w]
                                                        this.active[w] = false
                                                else
                                                        this.active[w] = true
                                close: ->
                                        for d in ['conta']
                                                this.active[d] = false
                        ready: ->
                                onClick = (e) ->
                                        if !e.target.parentNode.classList.contains('dropdown-menu')
                                                self.close()
                                window.addEventListener 'click', onClick, false
        
