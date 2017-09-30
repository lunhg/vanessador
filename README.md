# vanessador

Vanessador  um aplicativo firebase+typeform+express.js para gerenciar formulários

# Dependencias

## Debian

libsecret

    sudo apt-get install install libsecret-1-dev
    
# Instalando

    git clone https://www.github.com/lunhg/vanessador
    cd vanessador/
    npm install
    
#  Instalando chaves de acesso às APIs firebase, typeform, paypal e pagseguro

É possível executar um único comando:

    npm run build:API

Para entender o significado de cada uma, verifique os paragrafos abaixo:

##  Instalando chaves de acesso firebase

[Crie](https://firebase.google.com/docs/web/setup) um projeto firebase com as credenciais de chave de `API` e `messagingSenderId`:


    grunt build:firebase:apiKey
    grunt build:firebase:messagingSenderId
    
##  Instalando chaves de acesso typeform

[Crie](https://www.typeform.com/help/data-api/) um projeto typeform com as credenciais de chave de `API`:

    grunt build:typeform:apiKey

##  Instalando chaves de acesso paypal

[Crie](https://developer.paypal.com/developer/applications/) uma conta sandbox paypal com as credenciais de chave de `API` e `secret`:

    grunt build:paypal:apiKey
    grunt build:paypal:secret
    
##  Instalando chaves de acesso pagseguro

[Crie](https://pagseguro.uol.com.br/preferencias/integracoes.jhtml) uma conta sandbox pagseguro com as credenciais de chave de `API` e `email`:

    grunt build:pagseguro:apiKey
    grunt build:pagseguro:email

# Documentação

Toda documentação é gerada pelos comentários feitos nos códigos-fontes através do [docco](github.com/jashkenas/docco).

    npm run build:doc

# Executando

Um único comando compila o código-fonte e executa o servidor localizado em `bin/www`

    npm start

# Testes

O comando abaixo executa um teste que verifica se todas as funções do servidor localizado em `localhost:XXXX` (onde XXXX é uma porta, por exemplo, 3000):

   npm test
