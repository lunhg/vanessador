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
