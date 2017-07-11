# before starting the app, lets connect to firebase
__firebase__ = require("../package.json").firebase
firebase_manager = new FirebaseAdmin __firebase__.project.name

onMsg = (addr) ->"""
===* Vanessador server ready *===
* Express/Firebase Server
* started at #{Date.now()}
* available in
  #{addr.address}:#{addr.port}
================================="""


firebase_manager.init()
        .then(AppManager.make)
        .then(ServerManager.make)
        .then (addr) -> console.log chalk.cyan onMsg addr
        .catch (e) -> console.log e 
                        
