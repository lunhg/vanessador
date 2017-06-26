### Grunt tasks ###
path = require 'path'
each = require 'foreach'
require_from_package = require 'require-from-package'
check_node = require 'check_node'
prompt = require 'syncprompt'
keytar = require 'keytar'
        
module.exports = (grunt) ->
        pkg = grunt.file.readJSON('package.json')
        options = pkg.options;
        options.pkg = name: pkg.name, version: pkg.version

        # load task
        grunt.loadNpmTasks 'grunt-contrib-coffee'
        grunt.loadNpmTasks 'grunt-banner'
        grunt.registerTask 'build:init', 'An async configure task', ->
                done = @async()
                check_node (err, node_path) ->
                        if err then done(err)
                        grunt.config('pkg.node_version', node_path)
                        done()

        grunt.registerTask 'build:libs', 'An async library maker task', ->
                done = @async()
                require_from_package({
                        ext: 'coffee'
                        path: process.cwd()
                        destination: "boot"
                        pkg: pkg
                        core: ['fs', 'path', 'http']
                        validate: (name) ->
                                regexp = new RegExp("(grunt.*|check_node|require_from_package|syncprompt)")
                                !name.match(regexp)
                }, done)

        grunt.registerTask 'build:firebase:apiKey', 'Store firebase apiKey on keychain', ->
                done = @async()
                keytar.findPassword("#{pkg.name}.firebase.apiKey")
                        .then (r) ->
                                if r is undefined or r is null
                                        pwd = prompt("Type your #{pkg.firebase.project.name}.firebase.apiKey\n", secure:true)
                                        onSet = (r)->
                                                console.log "Firebase apiKey created"
                                                done()
                                        keytar.setPassword("#{pkg.firebase.project.name}.firebase.apiKey",pkg.author,pwd).then onSet

        grunt.registerTask 'build:firebase:messagingSenderId', 'Store firebase messagingSenderId on keychain', ->
                done = @async()
                keytar.findPassword("#{pkg.name}.firebase.messagingSenderId")
                        .then (r) ->
                                if r is undefined or r is null
                                        pwd = prompt("Type your #{pkg.firebase.project.name}.firebase.messagingSenderId\n", secure:true)
                                        onSet = (r)->
                                                console.log "Firebase messagingSenderId created"
                                                done()
                                        keytar.setPassword("#{pkg.firebase.project.name}.firebase.messagingSenderId",pkg.author,pwd).then onSet
                                        
        grunt.initConfig options
        
        # register tasks
        grunt.registerTask 'default', ['build:init', 'build:libs', 'coffee', 'usebanner']
