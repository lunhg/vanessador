var agent, chalk, fs, http, mocha, mocha_testdata, node_uuid, path, should, supertest, uuid;

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
    });
  });
});
