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

describe(chalk.green('Pagseguro API'), function() {
  var payment_id;
  agent = supertest.agent("http://localhost:3001");
  payment_id = "";
  it("should POST /pagseguro/planos/requerer\n(Permite criar um plano de pagamento recorrente que concentra todas as configurações de pagamento). Por exemplo, ao criar um curso, criamos um plano de pagamento específico para cada campanha de pagamentos.", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        var proxy;
        proxy = "https://fmdnocgd.p6.weaved.com";
        return agent.post("/pagseguro/planos/requerer").query({
          name: "Tributação e Internet: economia digital"
        }).query({
          amount: '172.42'
        }).query({
          redirect_url: proxy + "/#/boletos?type=pagseguro&type=redirect&id=762207c2-fb37-42ca-b555-fa4ce507ce8e"
        }).query({
          review_url: proxy + "/#/boletos?type=pagseguro&type=review&id=762207c2-fb37-42ca-b555-fa4ce507ce8e"
        }).query({
          details: "762207c2-fb37-42ca-b555-fa4ce507ce8e"
        }).expect(200).expect(function(res) {
          return console.log(res);
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
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
    });
  });
});
