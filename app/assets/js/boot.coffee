fetchMenu()
        .then fetchRoutes
        .then makeApp
        .then (_app) ->
                app = _app
                app.$mount("#app")                      
        .then ->
                document.getElementById('masterLoader').classList.add('hide')
        .catch (e) ->
                log "Error: #{e.code}\n #{e.message}"
