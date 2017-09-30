opt =
        controlPanelPort: 3002,
        servicePort: 3003,
        servicePort2: 3004
        hostname: '192.168.0.15',
        testsDir: 'TestCafe/tests',
        reportsPath: 'TestCafe/reports',
        browsers: {
                'Chromium': {
                        path: "/usr/bin/chromium-browser"
                }
        }
    
rpcPort = 3005

# Create TestCafé server instance with given options which can be accessed via RPC on port 1339.
testCafeServer = new TestCafeRemote.Server(opt, rpcPort);

#Returned object exposes standard TestCafé API, so you can use it as a regular TestCafé instance.
object = { browsers: testCafeServer.listAvailableBrowsers() }

testCafeServer.runTests object, (errors, taskUid, workers) ->
        console.log errors
        console.log taskUid
        console.log workers
