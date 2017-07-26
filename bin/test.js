var chalk, fs, http, mocha, mocha_testdata, path, should, supertest;

fs = require('fs');

path = require('path');

http = require('http');

chalk = require('chalk');

mocha = require('mocha');

mocha_testdata = require('mocha-testdata');

should = require('should');

supertest = require('supertest');

describe(chalk.green('Vanessador app'), function() {
  var agent, payment_id;
  agent = supertest.agent("http://localhost:3000");
  payment_id = "";
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
          console.log(e);
          e.should.have.property('template');
          e.should.have.property('route');
          e.should.have.property('controller');
          e.template.should.be.String();
          e.route.should.be.String();
          e.route.should.match(/\/(\w+(\/\w+)?)?/);
          e.controller.should.be.String();
          results.push(e.controller.should.match(/[A-Z][a-z]+[A-Z][a-z]+/));
        }
        return results;
      }).then(resolve)["catch"](reject);
    });
  });
  it('should GET /directives', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/directives").expect(200).expect('Content-Type', /json/).expect(function(res) {
        return console.log(res.body);
      }).then(resolve)["catch"](reject);
    });
  });
  it('should GET /services', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/services").expect(200).expect('Content-Type', /json/).expect(function(res) {
        return console.log(res.body);
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
  it("should GET /paypal/boletos/novo", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/paypal/invoices/novo").query({
        first_name: "Guilherme"
      }).query({
        second_name: "Martins"
      }).query({
        phone_country_code: "51"
      }).query({
        phone_national_number: "15998006760"
      }).query({
        line: "Rua Abolição 403, Ap. 13 - Vila Jardini"
      }).query({
        city: "Sorocaba"
      }).query({
        state: "SP"
      }).query({
        postal_code: "18044070"
      }).query({
        country_code: "BR"
      }).query({
        value: '10.00'
      }).query({
        billing_info_email: 'gcravista-buyer@gmail.com'
      }).query({
        form: 'lD26uE'
      }).expect(200).expect('Content-Type', /json/).expect(function(res) {
        payment_id = res.body.payment_id;
        return res.body.should.have.property('payment_id');
      }).then(resolve)["catch"](reject);
    });
  });
  it("should GET /paypal/invoices/:id", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/paypal/invoices/" + payment_id).expect(200).expect('Content-Type', /json/).expect(function(res) {
        return res.body.should.have.property('status');
      }).then(resolve)["catch"](reject);
    });
  });
  it("should GET /paypal/invoices/:id/send", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/paypal/invoices/" + payment_id + "/send").expect(200).expect(function(res) {
        return res.body.should.be.String();
      }).then(resolve)["catch"](reject);
    });
  });
  it("should GET /paypal/invoices/:id/remind", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/paypal/invoices/" + payment_id + "/remind").expect(200).expect(function(res) {
        return res.body.should.be.String();
      }).then(resolve)["catch"](reject);
    });
  });
  it("should GET /paypal/invoices/:id/cancel", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/paypal/invoices/" + payment_id + "/cancel").expect(200).expect(function(res) {
        return res.body.should.be.String();
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
