<<<<<<< HEAD
var agent, chalk, fs, http, mocha, mocha_testdata, node_uuid, path, should, supertest, uuid;
=======
var agent, chalk, fs, http, mocha, mocha_testdata, path, should, supertest, uuid;
>>>>>>> master

fs = require('fs');

path = require('path');

http = require('http');

chalk = require('chalk');

mocha = require('mocha');

mocha_testdata = require('mocha-testdata');

node_uuid = require('node-uuid');

should = require('should');

supertest = require('supertest');

uuid = require('uuid');

<<<<<<< HEAD
agent = supertest.agent("http://localhost:8000");

describe(chalk.green('Pagseguro API'), function() {
  it("should POST /pagseguro/boleto/gerar/id", function() {
    return new Promise(function(resolve, reject) {
      return agent.post("/pagseguro/boleto/gerar/id").expect(201).expect(function(res) {
        return res.body;
      }).then(resolve)["catch"](reject);
    });
  });
  return it("should POST /pagseguro/boleto/gerar", function() {
    return new Promise(function(resolve, reject) {
      return agent.post("/pagseguro/boleto/gerar").query({
        description: "Tributação e Internet: economia digital"
      }).query({
        name: 'Joao Comprador'
      }).query({
        email: 'c37421934304578448359@sandbox.pagseguro.com.br'
      }).query({
        city: 'Rio de Janeiro'
      }).query({
        state: 'RJ'
      }).query({
        amount: '172.42'
      }).query({
        cpf: '11111111111'
      }).query({
        hash: node_uuid.v4()
      }).query({
        id: node_uuid.v4()
      }).expect(201).expect(function(res) {
        return console.log(res.body);
      }).then(resolve)["catch"](reject);
=======
agent = supertest.agent("http://localhost:3000");

describe(chalk.green('Vanessador app client'), function() {
  return it('should GET / for first time', function() {
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
});

describe(chalk.green('Vanessador Docs'), function() {
  it("should GET /docs/server/boot/dependencies", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/boot/dependencies").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/boot/devDependencies", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/boot/devDependencies").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/boot/app", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/boot/app").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/boot/server", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/boot/server").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/config/environment", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/config/environment").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/config/app", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/config/app").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/config/server", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/config/server").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/config/paypal", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/config/paypal").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/config/pagseguro", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/config/pagseguro").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/app/controllers/index", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/app/controllers/index").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/app/controllers/config", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/app/controllers/config").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/app/controllers/services", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/app/controllers/services").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/app/controllers/templates", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/app/controllers/templates").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/app/controllers/typeform", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/app/controllers/typeform").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/server/app/controllers/paypal", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/app/controllers/paypal").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  return it("should GET /docs/server/app/controllers/pagseguro", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/server/app/controllers/pagseguro").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
});

describe(chalk.green('Vanessador Internal Rest API'), function() {
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
        ref = res.body;
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          e = ref[i];
          e.should.have.property('template');
          e.should.have.property('route');
          e.should.have.property('controller');
          e.template.should.be.String();
          e.route.should.be.String();
          results.push(e.route.should.match(/\/(\w+(\/\w+)?)?/));
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
  return it('should GET /services', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/services").expect(200).expect('Content-Type', /json/).expect(function(res) {
        return console.log(res.body);
      }).then(resolve)["catch"](reject);
    });
  });
});

describe(chalk.green('Typeform Data API'), function() {
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

describe(chalk.green('Paypal Invoice API'), function() {
  var payment_id;
  payment_id = "";
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
  it("should POST /paypal/boletos/novo", function() {
    return new Promise(function(resolve, reject) {
      return agent.post("/paypal/invoices/novo").query({
        first_name: "NodeJS"
      }).query({
        second_name: "Teste 2"
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
  return it("should DELETE /paypal/invoices/:id", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent["delete"]("/paypal/invoices/" + payment_id).expect(200).expect(function(res) {
          return res.body.should.be.String();
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
});

describe(chalk.green('Pagseguro Data API'), function() {
  var payment_id;
  payment_id = "";
  it("should GET /pagseguro/planos", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.get("/pagseguro/planos").expect(200).expect(function(res) {
          return console.log(res.body);
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  it("should GET /pagseguro/planos/notificacoes", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.get("/pagseguro/planos/notificacoes").expect(200).expect(function(res) {
          return console.log(res.body);
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  it("should GET /pagseguro/planos/requerer", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.get("/pagseguro/planos/requerer").expect(200).expect(function(res) {
          return console.log(res.body);
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  it("should POST /pagseguro/planos/requerer", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        var proxy;
        proxy = "https://ywsjzepx.p19.weaved.com/";
        return agent.post("/pagseguro/planos/requerer").query({
          name: "Teste de cobrança automática"
        }).query({
          amount: '10.00'
        }).query({
          redirect_url: proxy + "#!/boleto/pagseguro/redirect"
        }).query({
          review_url: proxy + "#!/boleto/pagseguro/review"
        }).query({
          details: "Plano de cobrança teste"
        }).expect(200).expect(function(res) {
          return console.log(res.body);
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  return it("should GET /pagseguro/planos/requerer", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.get("/pagseguro/planos/requerer").expect(200).expect(function(res) {
          return console.log(res.body);
        }).then(resolve)["catch"](reject);
      }, 1000);
>>>>>>> master
    });
  });
});
