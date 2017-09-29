ServerManager = {}
ServerManager.start = (app) ->
        self = this
        new Promise (resolve, reject) ->
                server = http.createServer app
                server.on 'error', (error) ->
                        if (error.syscall is 'listen') then throw error
                        bind = if (typeof(port) is 'string') then 'Pipe ' + port else 'Port ' + port
                        fn = (msg) ->
                                console.error(chalk.red(bind + ' ' + msg))
                                process.exit(1)
                
                        if (error.code is 'EACCES')
                                fn('requires elevated privileges')
                        else if (error.code is 'EADDRINUSE')
                                fn('is already in use')
                        else
                                reject error
                
                server.listen app.get('port'), 'localhost'
                server.on 'listening', ->
                        addr = server.address()
                        resolve addr
        
        

ServerManager.routes = ->
        new Promise (resolve, reject) ->
                try
                        # Start express server
                        app = express()

                        # this manage the routes
                        app_manager = new AppManager(app)
                                        
                        # use some middleware routines
                        app_manager.boot()
                
                        # our routes
                        # see /app/controllers
                        app_manager.index()
                        app_manager.config()
                        app_manager.templates()
                        app_manager.services()
                        app_manager.typeform()
                        app_manager.docs()
                        
                        # Send the configured express app to server
                        resolve app
                catch e
                        reject e
