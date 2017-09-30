TestCafe = 
path = require 'path'

require('testcafe')({
        controlPanelPort: 1337,
        servicePort1: 1338
        hostname: '127.0.0.1',
        testsDir: path.join(__dirname, '..', 'bin/test')
        reportsPath: path.join(__dirname, '..', 'test/reports')
        browsers:
                'Midori': {path: '/usr/bin/midori'}
                'Chromium': {path: '/usr/bin/chromium-browser'}
}).then (testcafe) ->
        runner = testcafe.createRunner()
        runner.src([
                path.join(__dirname, '..', 'bin/test', 'browser.test.js')
        ]).browsers(['Chromium']).run()
.then (failedCount) ->
        console.log('Tests failed: ' + failedCount);
        testcafe.close();
.catch (err) ->
        console.log err

