onMsg = (addr) ->"""
===* Vanessador server ready *===
* Express Server
* started at #{Date.now()}
* available in
  #{addr.address}:#{addr.port}
================================="""


# Boot life period
# - get the firebase project name, find the paypal apikeys
# - build a express app
# - bind the expresse app to a http server (handled by https proxy)
p = require('../package.json').firebase.project.name
Promise.all([keytar.findPassword("#{p}.paypal.apiKey"), keytar.findPassword("#{p}.paypal.secret")])
        #.then AppManager.initPayPal
        .then AppManager.initPagSeguro
        .then ServerManager.routes
        .then ServerManager.start
        .then (addr) -> console.log chalk.cyan onMsg addr
        .catch (e) -> console.log e 
                        
