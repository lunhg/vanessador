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
      return agent.post("/login").auth('email=lunhg@gmail.com', "password=..senha123").expect(function(res) {
        return console.log(res.body);
      }).then(resolve)["catch"](reject);
    });
  });
});
