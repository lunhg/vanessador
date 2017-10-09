# Vanessador

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

Crie um arquivo `.env` com as seguintes informações (IMPORTANTE: não suba este arquivo ao menos que estiver na fase de produção).

    VANESSADOR_ENV="<development | test | production>"  
    FIREBASE_API_KEY="<key>"
    FIREBASE_MESSAGING_SENDER_ID="<id>"
    MAILGUN_API_KEY="<key>"
    MAILGUN_DOMAIN="<domain>"
    TYPEFORM_API_KEY="<key>"
    APIS_EMAIL="<email>"
    PORT="<port>"

## Configure o modo da base de dados

Para maior organização, podemos atribuir base de dados diferentes para os modos `development`, `test`e `production` no arquivo `package.json` de acordo com o nome que o firebase atribui.

    "firebase": {
        "project": {
          "development": "vanessador-dev-zzzzz",
	  "test": "vanessador-test-yyyyy",
          "production": "vanessador-prod-xxxxx"
        }
    }

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
