ServerManager = {}
ServerManager.start = (app) ->
        self = this
        new Promise (resolve, reject) ->
                server = http.createServer app       
                server.listen app.get('port'), ->
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
