fs = require 'fs'
path = require 'path'
http = require 'http'
atob = require 'atob'
body_parser = require 'body-parser'
chalk = require 'chalk'
compression = require 'compression'
connect_assets = require 'connect-assets'
express = require 'express'
firebase_admin = require 'firebase-admin'
foreach = require 'foreach'
marked = require 'marked'
morgan = require 'morgan'
node_uuid = require 'node-uuid'
passport = require 'passport'
passport_custom = require 'passport-custom'
passport_firebase_auth = require 'passport-firebase-auth'
pug = require 'pug'
request_json = require 'request-json'
keytar = require 'keytar'