onMsg = (addr) ->"""
===* Vanessador server ready *===
* Express/Firebase Server
* started at #{Date.now()}
* available in
  #{addr.address}:#{addr.port}
================================="""

# before starting the app, lets connect to firebase
__firebase__ = require("../package.json").firebase
firebase_init(__firebase__.project.name).then (firebasePassportConfig) ->
        console.log firebasePassportConfig
        app = express()
        app_manager = new AppManager(app)

        # run all routines
        app_manager.init()
        app_manager.passport firebasePassportConfig
        app_manager.index()
        app_manager.login()
        app_manager.logout()
                
        
        # initialize server
        # TODO server = https.createServer app.get('https options'), app
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
                        throw error

        server.on 'listening', ->
                addr = server.address()
                console.log chalk.cyan onMsg addr


        server.listen app.get('port'), 'localhost'
