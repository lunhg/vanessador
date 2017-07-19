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
      var array;
      array = require('../package.json')['angular-templates'];
      array.push('route');
      return agent.get("/templates").expect(200).expect('Content-Type', /json/).expect(function(res) {
        var e, i, len, ref, results;
        console.log(res.body);
        ref = res.body;
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          e = ref[i];
          e.should.have.property('template');
          e.should.have.property('route');
          e.template.should.be.String();
          results.push(e.should.match(/\/([a-z]+)?/));
        }
        return results;
      }).then(resolve)["catch"](reject);
    });
  });
  it('should GET /services?q=dialog', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/services").query({
        q: 'dialog'
      }).expect(200).expect('Content-Type', /json/).expect(function(res) {
        console.log(res.body);
        res.body.should.have.property('restrict');
        res.body.should.have.property('scope');
        res.body.should.have.property('replace');
        res.body.should.have.property('scope');
        res.body.should.have.property('transclude');
        return res.body.should.have.property('template');
      }).then(resolve)["catch"](reject);
    });
  });
  it('should GET /typeform/data-api', function() {
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
  it("should GET /docs", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/app", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/app").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/services", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/run").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/config", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/config").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/auth-ctrl", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/auth-ctrl").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  return it("should GET /docs/run", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/run").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
});
