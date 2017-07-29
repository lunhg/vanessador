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
  it("should POST /paypal/boletos/novo", function() {
    return new Promise(function(resolve, reject) {
      return agent.post("/paypal/invoices/novo").query({
        first_name: "NodeJS"
      }).query({
        second_name: "Teste"
      }).query({
        phone_country_code: "51"
      }).query({
        phone_national_number: "1234567890"
      }).query({
        line: "Internet, Proxy IP"
      }).query({
        city: "Provedor"
      }).query({
        state: "Web"
      }).query({
        postal_code: "127.0.0.0"
      }).query({
        country_code: "BR"
      }).query({
        value: '10.00'
      }).query({
        billing_info_email: 'gcravista-buyer@gmail.com'
      }).query({
        form: 'lD26uE'
      }).expect(200).expect('Content-Type', /json/).expect(function(res) {
        payment_id = res.body;
        return res.body.should.match(/[A-Z0-9]+\-[A-Z0-9]+\-[A-Z0-9]+\-[A-Z0-9]+/);
      }).then(resolve)["catch"](reject);
    });
  });
  it("should GET /paypal/invoices/:id/number", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/paypal/invoices/" + payment_id + "/number").expect(200).expect('Content-Type', /json/).expect(function(res) {
        return res.body.should.match(/\d+/);
      }).then(resolve)["catch"](reject);
    });
  });
  it("should GET /paypal/invoices/:id/status", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/paypal/invoices/" + payment_id + "/status").expect(200).expect('Content-Type', /json/).expect(function(res) {
        return res.body.should.equal('DRAFT');
      }).then(resolve)["catch"](reject);
    });
  });
  it("should GET /paypal/invoices/:id/billing_info", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.get("/paypal/invoices/" + payment_id + "/billing_info").expect(200).expect('Content-Type', /json/).expect(function(res) {
          res.body.should.be.Array();
          res.body[0].should.be.Object();
          res.body[0].should.have.property('email');
          return res.body[0].email.should.match(/[a-z0-9]+\@[a-z]+\.[a-z]{3}/);
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  it("should GET /paypal/invoices/:id/invoice_date", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.get("/paypal/invoices/" + payment_id + "/invoice_date").expect(200).expect(function(res) {
          res.body.should.be.String();
          return res.body.should.match(/\d{4}\-\d{2}-\d{2}\s[A-Z]{3}/);
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  it("should GET /paypal/invoices/:id/total_amount", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.get("/paypal/invoices/" + payment_id + "/total_amount").expect(200).expect(function(res) {
          res.body.should.have.property('currency');
          res.body.should.have.property('value');
          res.body.currency.should.match(/[A-Z]{3}/);
          return res.body.value.should.match(/\d+\.\d+/);
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  it("should POST /paypal/invoices/:id/send", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.post("/paypal/invoices/" + payment_id + "/send").expect(200).expect('Content-Type', /json/).expect(function(res) {
          return res.body.should.be.String();
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  it("should GET /paypal/invoices/:id/status a second time with SENT status", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.get("/paypal/invoices/" + payment_id + "/status").expect(200).expect('Content-Type', /json/).expect(function(res) {
          return res.body.should.equal('SENT');
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  it("should POST /paypal/invoices/:id/remind", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.post("/paypal/invoices/" + payment_id + "/remind").expect(200).expect(function(res) {
          return res.body.should.be.String();
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  it("should POST /paypal/invoices/:id/cancel", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.post("/paypal/invoices/" + payment_id + "/cancel").expect(200).expect(function(res) {
          return res.body.should.be.String();
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  it("should GET /paypal/invoices/:id/status a third time, with status CANCELLED", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/paypal/invoices/" + payment_id + "/status").expect(200).expect('Content-Type', /json/).expect(function(res) {
        return res.body.should.equal('CANCELLED');
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
