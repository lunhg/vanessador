var chalk, fs, http, mocha, path, should, supertest;

fs = require('fs');

path = require('path');

http = require('http');

chalk = require('chalk');

mocha = require('mocha');

should = require('should');

supertest = require('supertest');

describe(chalk.green('Vanessador app'), function() {
  var agent;
  agent = supertest.agent("http://localhost:3000");
  it('should GET / for first time', function() {
    return new Promise(function(resolve, reject) {
      return agent.get('/').expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  return it('should GET /config', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/config").expect(200).expect('Content-Type', /json/).expect(function(res) {
        res.body.should.have.property('apiKey');
        return res.body.should.have.property('messagingSenderId');
      }).then(resolve)["catch"](reject);
    });
  });
});
