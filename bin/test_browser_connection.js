var _testcafe_, onRemoteConnection, onTestCafe, runner, testcafe;

testcafe = require('testcafe');

runner = null;

_testcafe_ = null;

onTestCafe = function(_testCafe_) {
  return new Promise(function(resolve, reject) {
    var err, error;
    try {
      _testcafe_ = _testCafe_;
      runner = _testcafe_.createRunner();
      return resolve(_testcafe_.createBrowserConnection());
    } catch (error) {
      err = error;
      return reject(err);
    }
  });
};

onRemoteConnection = function(remoteConnection) {
  return new Promise(function(resolve, reject) {
    console.log(remoteConnection.url);
    return remoteConnection.once('ready', function() {
      return runner.src(path.join(__dirname, 'test_browser.js')).browsers(remoteConnection).run().then(function(failedCount) {
        console.log(failedCount);
        return _testcafe.close();
      }).then(resolve)["catch"](reject);
    });
  });
};

testcafe('localhost', 1337, 1338).then(onTestCafe);
