# As diretivas seguirão o padrão descrito
# no tutorial elaborado por Adam Albrecht
# http://adamalbrecht.com/2013/12/12/creating-a-simple-modal-dialog-directive-in-angular-js/
# Vamos criar uma função para configurar no app.config
fetchDirectives = ->
        console.log "Aplicando diretivas..."
        # Asynchronously Bootstrapping AngularJS Applications with Server-Side Data
        # https://blog.mariusschulz.com/2014/10/22/asynchronously-bootstrapping-angularjs-applications-with-server-side-data
        this.directives = null
        self = this
        angular.injector(["ng"]).get("$http").get('/directives').then (directives) ->
                console.log directives
                a = []
             
                for d in directives.data
                        if d.name is 'dialog'
                                d.options.link = (scope, element, attrs) ->
                                        scope.dialogStyle = {}
                                        if attrs.width then scope.dialogStyle.width = attrs.width
                                        if attrs.height then cope.dialogStyle.height = attrs.height
                                        scope.hideModal = -> scope.show = false
                        a.push d.options

                [
                        {name:'modalDialog', fn: -> a[0]}
                        {name:'modalMenu', fn: -> a[1]}
                ]

