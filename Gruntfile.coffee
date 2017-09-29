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
        grunt.loadNpmTasks 'grunt-shell'
        
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


        grunt.registerTask 'build:doc:client', 'Build documentation with docco', ->
                grunt.config('doc_dir', "app/assets/doc")
                c = ""
                # Document all
                for p in [
                        {orig: "#{path.join(__dirname)}/boot", dest: "#{path.join(__dirname)}/app/assets/doc/boot", files: ['dependencies', 'devDependencies', 'app', 'server']}
                        {orig: "#{path.join(__dirname)}/config", dest: "#{path.join(__dirname)}/app/assets/doc/config", files: ['environment', 'app', 'server', 'paypal', 'pagseguro']}
                        {orig: "#{path.join(__dirname)}/app/controllers", dest: "#{path.join(__dirname)}/app/assets/doc/app/controllers", files: ['config', 'docs', 'index', 'pagseguro', 'paypal', 'services', 'templates', 'typeform']}
                        {orig: "#{path.join(__dirname)}/app/assets/js", dest: "#{path.join(__dirname)}/app/assets/doc/app/assets/js", files: ['index', 'app', 'config', 'auth-service', 'main-service', 'formulario-service', 'boleto-service', 'main-ctrl', 'run', 'directives', 'boot']}
                ]
                        
                        for path in p.files
                                f = "#{p.orig}/#{path}.coffee"
                                console.log "origin: #{f}"
                                console.log "dest: #{p.dest}"
                                c += ("docco #{f} -o #{p.dest} ; ")
        
                grunt.config('shell', {'docco': c})
                
                
        grunt.initConfig options
        
        # register tasks
        grunt.registerTask 'default', ['build:init', 'build:libs', 'coffee', 'usebanner']
