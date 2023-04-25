require 'csv'
require 'axlsx'
require_relative './features/hashs.rb'
require_relative './db/mongo.rb'
require_relative './features/getLocation.rb'
require_relative './features/createArchives.rb'

mongo = MongoInfoCompanies.new

loop do
  puts "MENU:"
  puts "1 - Realizar download dos arquivos ESTABELECIMENTOS."
  puts "2 - Descompactar e mudar extensão dos arquivos."
  puts "3 - Ler arquivo, criar hashs e enviar para DB."
  puts "4 - Percentual de empresas ativas"
  puts "5 - Contagem de aberturas de restaurantes por ano"
  puts "6 - Número de empresas em um raio de 5km do CEP 01422000"
  puts "7 - Tabela de correlação entre CNAE FISCAL PRINCIPAL e SECUNDÁRIA"
  puts "8 - Criar .csv com a opção 4,5,6,7."
  puts "9 - Criar .xlxs com a opção 4,5,6,7."
  puts "0 - Sair"
  print "Escolha uma opção: "

  escolha = gets.chomp.to_i

  case escolha

  when 1
      system("./features/bh/setup.sh")

  when 2
      system("./features/bh/unzip.sh")

  when 3
    mongo.add_companies(create_hashes())

  when 4
    percentual = mongo.percent_active_companies
    puts "Percentual de empresas ativas: #{percentual}%"

  when 5
    cursor = mongo.count_restaurant_openings_by_year
    cursor.each do |document|
      year = document['_id']
      count = document['count']
      puts "Em #{year}, foram abertas #{count} empresas de restaurantes."
    end

  when 6
    target = '01422-000'
    ceps = mongo.formatted_cep
    nearby_zipcodes_count= find_nearby_zipcodes(ceps,target)
    puts "Número de CEPs próximos: #{nearby_zipcodes_count}"

  when 7
    table = mongo.correlation_table
    table.each do |row|
      puts "#{row['_id']['CNAE FISCAL PRINCIPAL']} => #{row['_id']['CNAE FISCAL SECUNDARIA']}"
    end

  when 8
    create_csv(mongo)

  when 9
    create_xlsx(mongo)

  when 0
    break

  else
    puts "Opção inválida!"

  end

end
