# Este serviço será baseado
# no tutorial elaborado por Adam Albrecht
# http://adamalbrecht.com/2013/12/12/creating-a-simple-modal-dialog-directive-in-angular-js/
obj = {}

# Primeiro inicialize as rotas angular atraves
# de templates. Para recuperar esses templates, precisamos
# antes requerilos do servidor.
xhr = new XMLHttpRequest()
xhr.onreadystatechange = ->
        if @readyState is 4 and @status is 200

                # Este objeto é uma configuração parcial
                # do serviço requerido
                _obj = JSON.parse xhr.responseText
                obj = _obj

                # Agora precisamos criar o link
                obj.link = (scope, element, attrs) ->
                        scope.dialogStyle = {}
                        if (attrs.width)
                                scope.dialogStyle.width = attrs.width
                        if (attrs.height)
                                scope.dialogStyle.height = attrs.height;
                        scope.hideModal = -> scope.show = false
                        
# /services?q=modal é a rota contendo o
# compilador pug.js que cria
# os templates para as rotas angular
xhr.open('GET', '/services?q=dialog', true)
xhr.send()

ModalDialog = -> obj

app.directive 'modalDialog', ModalDialog
