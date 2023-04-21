require 'csv'
require 'axlsx'
require_relative './features/hashs.rb'
require_relative './db/mongo.rb'
require_relative './features/getLocation.rb'

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
      system("./features/bh/setupLinux.sh")

  when 2
      system("./features/bh/unzipLinux.sh")

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
    print "escolha o nome do arquivo: "
    filename =gets.chomp.to_s
    puts "criando arquivo, aguarde..."
    CSV.open("./exports/#{filename}.csv", "wb") do |csv|

      percentual = mongo.percent_active_companies
      csv << ["Percentual de empresas ativas", "#{(percentual).round(2)}%"]
      csv << []

      cursor = mongo.count_restaurant_openings_by_year
      csv << ["Aberturas Anuais", "Data", "Quantidade"]
      cursor.each do |document|
        year = document['_id']
        count = document['count']
        csv << ["Aberturas Anuais", "#{year}", count]
      end
      csv << []

      target = '01422-000'
      ceps = mongo.formatted_cep
      nearby_zipcodes_count = find_nearby_zipcodes(ceps, target)
      csv << ["CEPs próximos a #{target}", "Número de CEPs próximos", nearby_zipcodes_count]
      csv << []

      table = mongo.correlation_table
      csv << ["Tabela de correlação", "CNAE fiscal principal", "CNAE fiscal secundária"]
      table.each do |row|
        primary_cnae = row['_id']['CNAE FISCAL PRINCIPAL']
        secondary_cnae = row['_id']['CNAE FISCAL SECUNDARIA']
        csv << ["Tabela de correlação", primary_cnae, secondary_cnae]
      end
      puts "Arquivo #{filename} criado."
    end

  when 9
    print "Digite o nome do arquivo a ser criado: "
      filename = gets.chomp.to_s
      puts "Criando arquivo, aguarde..."

      Axlsx::Package.new do |wk|
        wk.use_shared_strings = true
        wk.workbook.add_worksheet(name: "Dados") do |sheet|

          centered_style = sheet.styles.add_style(alignment: {horizontal: :center})

          cursor = mongo.count_restaurant_openings_by_year
          percentual = mongo.percent_active_companies
          sheet.add_row ["Porcentagem de empresas ativas", "", "", "Quantidade de aberturas anuais"], style: centered_style
          sheet.add_row ["#{percentual}%", "", "", "Ano", "Quantidade"], style: centered_style
          cursor.each do |document|
            year = document['_id']
            count = document['count']
            sheet.add_row [ "", "", "", year, count], style: centered_style
          end
          sheet.add_row [], style: centered_style

          target = '01422-000'
          ceps = mongo.formatted_cep
          nearby_zipcodes_count = find_nearby_zipcodes(ceps, target)



          table = mongo.correlation_table
          sheet.add_row [ "Tabela de correlação", "", "", "CEPs próximos a #{target}"], style: centered_style
          sheet.add_row ["CNAE fiscal principal", "CNAE fiscal secundária", "", nearby_zipcodes_count], style: centered_style
          table.each do |row|
            primary_cnae = row['_id']['CNAE FISCAL PRINCIPAL']
            secondary_cnae = row['_id']['CNAE FISCAL SECUNDARIA']
            sheet.add_row [primary_cnae, secondary_cnae], style: centered_style
          end
        end
        puts "arquivo #{filename} criado."

        wk.serialize("./exports/#{filename}.xlsx")

      end

  when 0

    break

  else

    puts "Opção inválida!"

  end

end
