runner = null
testcafe = null

_testcafe = createTestCafe('localhost', 1337, 1338)
onTestCafe = (_testCafe) ->
        new Promise (resolve, reject) ->
                try
                        testcafe = _testCafe_
                        runner   = testcafe.createRunner()
                        resolve testcafe.createBrowserConnection()
                catch err
                        reject err
                        
_testcafe.then onTestCafe
        .then (remoteConnection) ->
                new Promise (resolve, reject) ->
                        console.log(remoteConnection.url);
                        remoteConnection.once 'ready', ->
                                runner.src(path.join(__dirname, 'test_browser.js'))
                                        .browsers(remoteConnection)
                                        .run()
                                        .then (failedCount) ->
                                                console.log(failedCount)
                                                testcafe.close()
                                        .then resolve
                                        .catch reject
