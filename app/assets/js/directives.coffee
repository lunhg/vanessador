# As diretivas seguirão o padrão descrito
# no tutorial elaborado por Adam Albrecht
# http://adamalbrecht.com/2013/12/12/creating-a-simple-modal-dialog-directive-in-angular-js/
# Vamos criar uma função para configurar no app.config
fetchDirectives = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Aplicando diretivas..."
        # Asynchronously Bootstrapping AngularJS Applications with Server-Side Data
        # https://blog.mariusschulz.com/2014/10/22/asynchronously-bootstrapping-angularjs-applications-with-server-side-data
        angular.injector(["ng"]).get("$http").get('/directives')
