document.addEventListener 'DOMContentLoaded', (event)->

        fetchConfig().then(fetchAuthService)
                .then (service) ->
                        app.service("authService", service)
                .then(fetchFormularioService)
                .then (service) ->
                        app.service("formularioService", service)
                .then(fetchBoletoService)
                .then (service) ->
                        app.service("boletoService", service)
                .then(fetchMainService)
                .then (service) ->
                        app.service("mainService", service)
                .then(fetchMainCtrl)
                .then (MainCtrl) ->
                        app.controller('MainCtrl', [
                                '$rootScope'
                                '$http'
                                '$location'
                                '$route'
                                '$window'
                                '$cookies'
                                '$q'
                                'authService'
                                'formularioService'
                                'boletoService'
                                'mainService'
                                'toastr'
                                 MainCtrl
                        ])
                .then (fetchRun)
                .then (Run) ->
                        app.run([
                                '$rootScope'
                                '$http'
                                '$location'
                                '$timeout'
                                'mainService'
                                 Run
                        ])
                .then(fetchDirectives)
                .then (directives) ->
                        for directive in directives.data
                                name = 'modal'+directive.name.charAt(0).toUpperCase()+directive.name.slice(1)
                                app.directive(name, -> directive.options) 
                        ["vanessador"]
                .then (apps) ->
                        # A mensagem de carregamento inicial
                        # deve ser atualizada
                        loader = document.getElementById('masterLoader')
                        p = loader.children[9]
                        p.innerHTML = "Pronto!"
                        document.getElementById('masterLoader').classList.add('hide')
                        angular.bootstrap(document, apps)
                .catch (e) ->
                        # A mensagem de carregamento inicial
                        # deve ser atualizada
                        loader = document.getElementById('masterLoader')
                        p = loader.children[9]
                        p.innerHTML = e
