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

## Nos sistemas Linux

Edite o arquivo `~/.profile` com as seguintes informações:

    export FIREBASE_API_KEY=<key>
    export FIREBASE_MESSAGING_SENDER_ID=<id>
    export MAILGUN_API_KEY=<key>
    export MAILGUN_DOMAIN=<domain>
    export TYPEFORM_API_KEY=<key>
    export APIS_EMAIL=<email>
    export PORT=<port>

# Documentação

Toda documentação é gerada pelos comentários feitos nos códigos-fontes através do [docco](github.com/jashkenas/docco).

    npm run build:doc

# Executando

Um único comando compila o código-fonte e executa o servidor localizado em `bin/www`

    npm start

ou

    npm run build:app

# Testes

O comando abaixo executa um teste que verifica se todas as funções do servidor localizado em `localhost:XXXX` (onde XXXX é uma porta, por exemplo, 3000):

   npm test
