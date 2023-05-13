# DataOPS Ruby
O projeto consiste com uma funcionalidade de fazer o download dos arquivos .ESTABELE do site do governo, inserir tudo no mongoDB e manipulando seus dados diretamente do DB. Agora um pouco dos seus topicos. 

## Tecnologias:

- Ruby 3.0.2 : Usado para criar toda a logica e funcionalidade da aplicação.

- Shell Script : Comandos em shell para realizar tarefas de downloads e unzip.

- Docker : Foi usado o docker por ser mais pratico e facil "subir" a imagem do banco de dados usando conteiner, porem em uma situação de produção seria necessario ter cuidado com os dados. Observação: É usado os "volumes",então é feito um espaço compartilhado entre o container e o host, devido a isso se excluir ou derrubar o conteiner não sera perdido o dados do DB. Caso já tenha o mongo instalado e funcionando na sua máquina, não é necessária o uso do docker compose.

- Mongodb : Usado para armazenar os dados.

## Objetivos dos arquivos:

- setup.sh : É um script shell que vai ate o site do governo e faz o download de todos arquivos .ESTABELE, cria uma caminho na raiz do projeto chamada DataCNPJ/zip e aqui dentro vai todos os arquivos feitos pelo download. Caso ja tenha baixado os arquivos é so criar o caminho.

- unzip.sh : É um script shell que vai na pasta DataCNPJ/zip criada pelo setup.sh e descompacta todos os arquivos e os armazena na pasta DataCNPJ/unzipped. Caso ja tenha baixado os arquivos é so criar o caminho.

- hashs.rb : Esse tem uma função le todos arquivos que estão em DataCNPJ/unzipped e cria hashs para cada estabelecimento.

- getLocation.rb : Logica que faz a comparação de distancia entre o cep "01422-000" com todos outros que estão no cando de dados. Utiliza a API nomatim para converter o CEP em coordenadas geograficas latitute e longitute,depois calculo a distancia entre os dois pontos usando formula de haversine, é uma equação usada para calcular a distância entre dois pontos em uma esfera, como a Terra.

- mongo.rb : Tem uma classe que recebe parametros de conexão com o banco de dados e tem modulos que realizam consultas necessarias para a funcionalidade da aplicação.

## Main.rb
O arquivo main herda todos outros arquivos e cria um menu onde voce pode realizar o download,descompactar, ler os arquivos e criar hashs inserindo-os no banco de dados,receber o percentual de empresas ativas, contagem de empresas abertar por ano, número de empresas num raio de 5km do cep "01422-000",tabela de correlação entre CNAE FISCAL PRINCIPAL e SECUNDÁRIA, além de voce poder exportar todas essas informações em um arquivo .csv ou .xlsx que é exportado para a pasta "exports".

# Como usar:
Primeiramente você precisa de todas dependencias instaladas, que são:

-  axlsx
-  csv
-  mongo
-  httparty
-  dotenv

No projeto tem o arquivo "Gemfile" que ao você executar o comando "bundle install" ele ja instala todos pacotes.

E para os script shell conseguirem ser executados é necessario um "chmod +x features/bh/setupLinux.sh","chmod +x features/bh/unzipLinux.sh" estando no linux para ter permissão de executar o arquivo. Replique a logica do arquivo ".env.example" e cria seu proprio .env com a url de conexão.
Sendo assim, só iniciar o arquivo main.rb e seguir o menu.

