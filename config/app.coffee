class AppManager

        constructor: (@app) ->
                @app.set 'views', path.join(__dirname, '..', 'app/views/')
        
                # View server engine that will be used with Angular
                @app.engine 'pug', (file_path, options, _callback) ->
                        fs.readFile file_path, 'utf8', (err, content) ->
                                if err then _callback(err)
                                fn = pug.compile content, {filename: file_path, doctype:'html'}        
                                _callback null, fn({filters: [ marked ]})
                
                @app.set 'view engine', 'pug'

                # Assets
                @app.set 'assets path', [
                        path.join __dirname, '..', 'app/assets/img'
                        path.join __dirname, '..', 'app/assets/css'
                        path.join __dirname, '..', 'app/assets/js'
                        path.join __dirname, '..', 'app/assets/'
                        #path.join __dirname, '..', 'app/assets/favicon.ico'
                ]

                @app.set 'port', parseInt(process.env.PORT || '3000')

# Init lifetime
# - configure a basic express app
# - configure passport.js
# - initialize routines (log, assets, ...)
# - initialize mount points (index and json API)
# - initialize typeform
AppManager.init = (result) ->
        new Promise (resolve, reject) ->
                app = express()
                app_manager = new AppManager(app)

                # run passport first
                app_manager.passport()
                
                # use some middleware routines
                app_manager.boot()

                # our routes
                app_manager.index()
                app_manager.login()
                app_manager.config()
                app_manager.templates()
                app_manager.typeform()

                # Send to server
                resolve app
