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
    
##  Instalando chaves de acesso firebase

    grunt build:firebase:apiKey
    grunt build:firebase:messagingSenderId
    
##  Instalando chaves de acesso typeform

    grunt build:typeform:apiKey

##  Instalando chaves de acesso paypal

    grunt build:paypal:apiKey
    grunt build:paypal:secret
    
##  Instalando chaves de acesso pagseguro

    grunt build:pagseguro:apiKey
    grunt build:pagseguro:email
    
# Executando

    npm start
