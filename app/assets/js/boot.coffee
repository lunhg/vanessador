window.app = null
fetchConfig().then fetchMenu
        .then fetchRoutes
        .then makeApp
        .then (_app) ->
                window.app = _app
                window.app.$mount("#app")                      
        .then ->
                document.getElementById('masterLoader').classList.add('hide')
                
                $ ->
                        $('.navbar-toggle').click ->
                                $('.navbar-nav').toggleClass('slide-in')
                                $('.side-body').toggleClass('body-slide-in')
                                $('#search').removeClass('in').addClass('collapse').slideUp(200)

                        search = false
                        # Remove menu for searching
                        $('#search-trigger').click ->
                                if not search
                                        $('#search').removeClass('collapse').addClass('in').slideDown(200)
                                        $('.list-group-item').slideDown(200)
                                        search = true
                                else
                                        $('#search').removeClass('in').addClass('collapse').slideUp(200)
                                        $('.list-group-item').addClass('hide').slideUp(200)
                                        search = false
        .catch (e) ->
                log "Error: #{e.code}\n #{e.message}\n#{e.stack}"


