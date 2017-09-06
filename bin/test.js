var chalk, fs, http, mocha, mocha_testdata, path, should, supertest, uuid;

fs = require('fs');

path = require('path');

http = require('http');

chalk = require('chalk');

mocha = require('mocha');

mocha_testdata = require('mocha-testdata');

should = require('should');

supertest = require('supertest');

uuid = require('uuid');

describe(chalk.green('Vanessador app'), function() {
  var agent, payment_id;
  agent = supertest.agent("http://localhost:3001");
  payment_id = "";
  it("should POST /pagseguro/planos/requerer\n(Permite criar um plano de pagamento recorrente que concentra todas as configurações de pagamento).", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        var proxy;
        proxy = "https://ywsjzepx.p19.weaved.com/";
        return agent.post("/pagseguro/planos/requerer").query({
          name: "Boleto Teste"
        }).query({
          amount: '10.00'
        }).query({
          redirect_url: proxy + "/#/boleto/pagseguro/redirect"
        }).query({
          review_url: proxy + "#/boleto/pagseguro/review"
        }).query({
          details: "Plano de cobrança teste"
        }).expect(200).expect(function(res) {
          console.log(res.body);
          return payment_id = res.body["preApprovalRequest"]["code"][0];
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  it("should GET /pagseguro/planos/requerer", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.get("/pagseguro/planos/requerer").expect(200).expect(function(res) {
          return res.body.should.be.deepEqual({});
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
  return it("should PUT /pagseguro/planos/:id", function() {
    return new Promise(function(resolve, reject) {
      return setTimeout(function() {
        return agent.put("/pagseguro/planos/" + payment_id).query({
          amount: '11.00'
        }).query({
          update: false
        }).expect(200).expect(function(res) {
          return console.log(res.body);
        }).then(resolve)["catch"](reject);
      }, 1000);
    });
  });
});
