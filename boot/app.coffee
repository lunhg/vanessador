AppManager::boot = ->
        # Favicon
        #app.use favicon(app.get('assets path')[4])
        
        # Logger
        @app.use morgan(':method :url :status Content-Lenght: :res[content-length] time: :response-time ms')
        
        # Compression
        @app.use compression()
        
        # Body parsers
        @app.use body_parser.json()
        @app.use body_parser.urlencoded({ extended: false })
        
        # Assets
        @app.use connect_assets(paths: @app.get('assets path'))
