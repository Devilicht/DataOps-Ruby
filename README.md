# DataOPS Ruby
O projeto consiste com uma funcionalidade de fazer o download dos arquivos .ESTABELE do site do governo, inserir tudo no mongoDB e manipulando seus dados diretamente do DB. Agora um pouco dos seus topicos.

## Tecnologias e dependecias:
- Docker : Foi usado o docker por ser mais pratico e facil "subir" a imagem do banco de dados usando conteiner, porem em uma situação de produção seria necessario ter cuidado com os dados. Observação: É usado os "volumes",então é feito um espaço compartilhado entre o container e o host, devido a isso se excluir ou derrubar o conteiner não sera perdido o dados do DB.

## Objetivos dos arquivos:

- setup.sh : É um script shell que vai ate o site do governo e faz o download de todos arquivos .ESTABELE, cria uma caminho na raiz do projeto chamada DataCNPJ/zip e aqui dentro vai todos os arquivos feitos pelo download. Caso ja tenha baixado os arquivos é so criar o caminho.

- unzip.sh : É um script shell que vai na pasta DataCNPJ/zip criada pelo setup.sh e descompacta todos os arquivos e os armazena na pasta DataCNPJ/unzipped. Caso ja tenha baixado os arquivos é so criar o caminho.

- hashs.rb : Esse tem uma função le todos arquivos que estão em DataCNPJ/unzipped e cria hashs para cada estabelecimento.

- getLocation : Logica que faz a comparação de distancia entre o cep "01422-000" com todos outros que estão no cando de dados. Utiliza a API nomatim para converter o CEP em coordenadas geograficas latitute e longitute,depois calculo a distancia entre os dois pontos usando formula de haversine, é uma equação usada para calcular a distância entre dois pontos em uma esfera, como a Terra.

- mongo.rb : Tem uma classe que recebe parametros de conexão com o banco de dados e tem modulos que realizam consultas necessarias para a funcionalidade da aplicação.

## Main.rb:
O arquivo main herda todos outros arquivos e cria um menu onde voce pode realizar o download,descompactar, ler os arquivos e criar hashs inserindo-os no banco de dados,receber o percentual de empresas ativas, contagem de empresas abertar por ano, número de empresas num raio de 5km do cep "01422-000",tabela de correlação entre NAE FISCAL PRINCIPAL e SECUNDÁRIA, além de voce poder exportar todas essas informações em um arquivo .csv ou .xlxs que é exportado para a pasta "exports".

# Como usar:
Primeiramente você precisa de todas dependencias instaladas além de subir o docker compose, entre elas são:

- gem install axlxs
- gem install csv
- gem install mongo
- gem install httparty

E para os script shell conseguirem ser executados é necessario um "chmod +x features/bh/setupLinux.sh","chmod +x features/bh/unzipLinux.sh" estando no linux para ter permissão de executar o arquivo.
Sendo assim, só iniciar o arquivo main.rb e seguir o menu.

Segue um video com uma explicação melhor sobre:




"https://drive.google.com/file/d/1Mdw6D_yRJp3e547debwiinDTvC6E_dcp/view?usp=share_link"
