bibliotecaDaniell
=================

Mini sistema de biblioteca usando ruby on rails

Deploy da aplicacao:  http://bibliotecadaniell.herokuapp.com/

Voce pode criar um novo usuario ou entrar com o usuario:

Login: admin@email.com
Senha: 12345678


Get Started

-Antes de rodar instale o gem nokogiri para instalar siga os seguintes passos:

1-  Instale as bibliotecas linux que o nokogiri precisa:

sudo apt-get install libxslt-dev libxml2-dev

2 - Instale o gem nokogiri:

sudo gem install nokogiri


- Se voce estiver usando o rake versao 10.0.4 rode o rake usando a seguinte linha de comando:

bundle exec rake db:create    

bundle exec rake db:migrate
