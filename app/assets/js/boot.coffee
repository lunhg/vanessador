document.addEventListener 'DOMContentLoaded', (event)->

        fetchConfig().then(fetchServices)
                .then (services) ->
                        app.service("#{service}", v) for service, v of services
                .then(fetchAuthCtrl)
                .then (AuthCtrl) ->
                        # Registre o controlador
                        app.controller "AuthCtrl", ['$rootScope','$http','$location','$window', '$route', 'toastr', AuthCtrl]
                .then(fetchTypeform)
                .then (TypeformCtrl) ->
                        # Registre o controlador
                        app.controller "TypeformCtrl", ['$rootScope','$http','$location','$window','$controller', 'toastr', 'formularioService', 'boletoService', TypeformCtrl]
                .then(fetchPaypal)
                .then (PaypalCtrl) ->
                        # Registre o controlador
                        app.controller "PaypalCtrl", ['$rootScope','$http','$location','$window','$controller', 'toastr', 'boletoService', PaypalCtrl]
                .then(fetchRun)
                .then (Run) ->
                        app.run(['$rootScope', '$http', '$location', '$route', '$window', Run])
                .then(fetchDirectives)
                .then (directives) ->
                        app.directive(_directive.name, _directive.fn) for _directive in directives
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
