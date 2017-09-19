var agent, chalk, fs, http, mocha, mocha_testdata, path, should, supertest, uuid;

fs = require('fs');

path = require('path');

http = require('http');

chalk = require('chalk');

mocha = require('mocha');

mocha_testdata = require('mocha-testdata');

should = require('should');

supertest = require('supertest');

uuid = require('uuid');

agent = supertest.agent("http://localhost:3001");

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

describe(chalk.green('Vanessador Internal Rest API'), function() {
  var routes;
  routes = [];
  it('should GET /config', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/config").expect(200).expect('Content-Type', /json/).expect(function(res) {
        res.body.should.have.property('apiKey');
        return res.body.should.have.property('messagingSenderId');
      }).then(resolve)["catch"](reject);
    });
  });
  it('should GET /templates/index/page', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates/index/page").expect(200).expect('Content-Type', /html/).then(resolve)["catch"](reject);
    });
  });
  it('should GET /templates/index/data', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates/index/data").expect(200).expect('Content-Type', /json/).expect(function(res) {
        return res.body.should.be.an.Object();
      }).then(resolve)["catch"](reject);
    });
  });
  it('should GET /templates/index/routes', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates/index/routes").expect(200).expect('Content-Type', /json/).expect(function(res) {
        routes = res.body;
        return res.body.should.be.an.Array();
      }).then(resolve)["catch"](reject);
    });
  });
  it('should GET /templates/routes/_index', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates/routes/page").expect(200).expect('Content-Type', /json/).then(resolve)["catch"](reject);
    });
  });
  it('should GET /templates/routes/login', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates/routes/page").expect(200).expect('Content-Type', /json/).then(resolve)["catch"](reject);
    });
  });
  it('should GET /templates/routes/signup', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates/routes/page").expect(200).expect('Content-Type', /json/).then(resolve)["catch"](reject);
    });
  });
  it('should GET /templates/routes/confirm', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates/routes/page").expect(200).expect('Content-Type', /json/).then(resolve)["catch"](reject);
    });
  });
  it('should GET /templates/routes/formularios', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates/routes/formularios").expect(200).expect('Content-Type', /json/).then(resolve)["catch"](reject);
    });
  });
  it('should GET /templates/routes/estudantes', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates/routes/estudantes").expect(200).expect('Content-Type', /json/).then(resolve)["catch"](reject);
    });
  });
  it('should GET /templates/routes/cursos', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates/routes/cursos").expect(200).expect('Content-Type', /json/).then(resolve)["catch"](reject);
    });
  });
  return it('should GET /templates/routes/matriculas', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/templates/routes/matriculas").expect(200).expect('Content-Type', /json/).then(resolve)["catch"](reject);
    });
  });
});

describe(chalk.green('Vanessador Docs'), function() {
  it("should GET /docs/boot/dependencies", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/boot/dependencies").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/boot/devDependencies", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/boot/devDependencies").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/boot/server", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/boot/server").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/config/environment", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/config/environment").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/config/app", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/config/app").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/config/pagseguro", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/config/pagseguro").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/config/server", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/config/server").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/boot/app", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/boot/app").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/app/controllers/index", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/app/controllers/index").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/app/controllers/config", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/app/controllers/config").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/app/controllers/templates", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/app/controllers/templates").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/app/controllers/services", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/app/controllers/services").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/app/controllers/typeform", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/app/controllers/typeform").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/app/controllers/pagseguro", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/app/controllers/pagseguro").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/app/controllers/mailer", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/app/controllers/mailer").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/app/controllers/docs", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/app/controllers/docs").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/test/agent", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/test/agent").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  it("should GET /docs/test/internal", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/test/internal").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
  return it("should GET /docs/test/docs", function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/docs/test/docs").expect(200).expect('Content-Type', /html/).end(function(err, res) {
        if (!err) {
          return resolve();
        } else {
          return reject(err);
        }
      });
    });
  });
});

describe(chalk.green('Typeform Data API'), function() {
  return it('should GET /typeform/data-api', function() {
    return new Promise(function(resolve, reject) {
      return agent.get("/typeform/data-api").query({
        uuid: 'E20qGg'
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

describe(chalk.green('Vanessador app mailer'), function() {
  return it('should POST /mailer/send/boleto for first time', function() {
    return new Promise(function(resolve, reject) {
      return agent.post('/mailer/send/boleto').query({
        subject: "Boleto - Curso Privacidade: Desafios e oportunidades"
      }).query({
        to: "\"Guilherme Lunhani\" <gcravista@gmail.com>"
      }).query({
        alumni: 0
      }).expect(201).expect('Content-Type', /json/).expect(function(res) {
        console.log(res.body);
        res.body.should.have.property('message');
        return res.body.should.have.property('id');
      }).then(resolve)["catch"](reject);
    });
  });
});
