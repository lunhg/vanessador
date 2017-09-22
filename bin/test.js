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

agent = supertest.agent("http://localhost:8000");

describe(chalk.green('Pagseguro API'), function() {
  it("should POST /pagseguro/boleto/gerar/id", function() {
    return new Promise(function(resolve, reject) {
      return agent.post("/pagseguro/boleto/gerar/id").expect(200).expect(function(res) {
        return console.log(res.body);
      }).then(resolve)["catch"](reject);
    });
  });
  return it("should POST /pagseguro/boleto/gerar", function() {
    return new Promise(function(resolve, reject) {
      return agent.post("/pagseguro/boleto/gerar").query({
        description: "Tributação e Internet: economia digital"
      }).query({
        amount: '172.42'
      }).query({
        to: 'gcravista@gmail.com'
      }).expect(200).expect(function(res) {
        return console.log(res.body);
      }).then(resolve)["catch"](reject);
    });
  });
});
