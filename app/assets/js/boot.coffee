document.addEventListener 'DOMContentLoaded', (event)->
        console.log("DOM fully loaded and parsed");
        console.log("Loading vanessador...");

        fetchConfig().then(fetchAuthCtrl)
                .then (AuthCtrl) ->
                        # Registre o controlador
                        app.controller "AuthCtrl", ['$rootScope','$http','$location','$window','$route', 'dialogService', AuthCtrl]
                .then(fetchTypeform)
                .then (TypeformCtrl) ->
                        # Registre o controlador
                        app.controller "TypeformCtrl", ['$rootScope','$http','$location','$window','dialog',TypeformCtrl]
                .then(fetchServices)
                .then (services) ->
                        app.factory "#{k}", v for k, v of services
                                
                .then(fetchRun)
                .then (Run) ->
                        app.run(['$rootScope', '$http', '$location', '$route', '$window', Run])
                .then(fetchDirectives)
                .then (directives) ->
                        for _directive in directives
                                console.log _directive
                                app.directive(_directive.name, _directive.fn)
                        ["vanessador"]
                .then (apps) ->
                        console.log "Done."
                        console.log "bootstraping #{_app}" for _app in apps
                        angular.bootstrap(document, apps)
                .catch (e) ->
                        console.log e
