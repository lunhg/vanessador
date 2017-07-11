var chalk, fs, http, keytar, mocha, path, should, supertest;

fs = require('fs');

path = require('path');

http = require('http');

chalk = require('chalk');

keytar = require('keytar');

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
  return it('should POST /login', function() {
    return new Promise(function(resolve, reject) {
      return agent.post("/login").query({
        email: "lunhanig@gmail.com"
      }).expect(200).expect('Content-Type', /json/).expect(function(res) {
        res.body.should.have.property('uid');
        res.body.uid.should.be.String();
        res.body.should.have.property('info');
        res.body.info.should.have.property('customToken');
        return res.body.info.customToken.should.be.String();
      }).then(resolve)["catch"](reject);
    });
  });
});
