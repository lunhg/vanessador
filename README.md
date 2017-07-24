# vanessador

Vanessador  um aplicativo firebase+typeform+express.js para gerenciar formulários

# Dependencias

## Debian

- libsecret

    sudo apt-get install install libsecret-1-dev
    
# Instalando

    git clone https://www.github.com/lunhg/vanessador
    cd vanessador/
    npm install
    
##  Instalando chaves de acesso firebase

    npm build build:firebase:apiKey
    npm build build:firebase:messagingSenderId
    
##  Instalando chaves de acesso typeform

    grunt build build:typeform:apiKey
    
# Executando

    npm start
