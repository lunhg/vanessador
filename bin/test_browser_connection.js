var _testcafe, onTestCafe, runner, testcafe;

runner = null;

testcafe = null;

_testcafe = createTestCafe('localhost', 1337, 1338);

onTestCafe = function(_testCafe) {
  return new Promise(function(resolve, reject) {
    var err, error;
    try {
      testcafe = _testCafe_;
      runner = testcafe.createRunner();
      return resolve(testcafe.createBrowserConnection());
    } catch (error) {
      err = error;
      return reject(err);
    }
  });
};

_testcafe.then(onTestCafe).then(function(remoteConnection) {
  return new Promise(function(resolve, reject) {
    console.log(remoteConnection.url);
    return remoteConnection.once('ready', function() {
      return runner.src(path.join(__dirname, 'test_browser.js')).browsers(remoteConnection).run().then(function(failedCount) {
        console.log(failedCount);
        return testcafe.close();
      }).then(resolve)["catch"](reject);
    });
  });
});
