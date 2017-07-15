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
  it('should GET /config', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/config").expect(200).expect('Content-Type', /json/).expect(function(res) {
        res.body.should.have.property('apiKey');
        return res.body.should.have.property('messagingSenderId');
      }).then(resolve)["catch"](reject);
    });
  });
  it('should GET /templates', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates").expect(200).expect('Content-Type', /json/).expect(function(res) {
        console.log(res.body);
        res.body.should.have.property('_index');
        res.body.should.have.property('signup');
        res.body.should.have.property('login');
        return res.body.should.have.property('resetPassword');
      }).then(resolve)["catch"](reject);
    });
  });
  return it('should GET /typeform/data-api', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/typeform/data-api").query({
        uuid: 'lD2u6E'
      }).query({
        completed: true
      }).query({
        limit: 10
      }).expect(200).expect('Content-Type', /json/).expect(function(res) {
        res.body.should.have.property('stats');
        res.body.stats.should.have.property('responses');
        res.body.stats.responses.should.have.property('showing');
        res.body.stats.responses.should.have.property('total');
        res.body.stats.responses.should.have.property('completed');
        return res.body.should.have.property('questions');
      }).then(resolve)["catch"](reject);
    });
  });
});
