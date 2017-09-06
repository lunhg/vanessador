fetchConfig().then (config) -> if firebase.apps.length is 0 then firebase.initializeApp(config.data)
        .then fetchMenu
        .then fetchRoutes
        .then makeApp
        .then (_app) ->
                app = _app
                app.$mount("#app")                      
        .then ->
                document.getElementById('masterLoader').classList.add('hide')
                $(document).ready ->
                        $('.navbar-toggle').click ->
                                $('.navbar-nav').toggleClass('slide-in')
                                $('.side-body').toggleClass('body-slide-in')
                                $('#search').removeClass('in').addClass('collapse').slideUp(200)

                                # uncomment code for absolute positioning tweek see top comment in css
                                #$('.absolute-wrapper').toggleClass('slide-in');
   
                        # Remove menu for searching
                        $('#search-trigger').click ->
                                $('.navbar-nav').removeClass('slide-in')
                                $('.side-body').removeClass('body-slide-in')

                                # uncomment code for absolute positioning tweek see top comment in css
                                #$('.absolute-wrapper').removeClass('slide-in')
        .catch (e) ->
                log "Error: #{e.code}\n #{e.message}\n#{e.stack}"


