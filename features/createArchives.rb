def create_xlsx(mongo)
  print "Digite o nome do arquivo a ser criado: "
    filename = gets.chomp.to_s
    puts "Criando arquivo, aguarde..."

    Axlsx::Package.new do |wk|
      wk.use_shared_strings = true
      wk.workbook.add_worksheet(name: "Dados") do |sheet|

        centered_style = sheet.styles.add_style(alignment: {horizontal: :center})
        target = '01422-000'
        ceps = mongo.formatted_cep
        nearby_zipcodes_count = find_nearby_zipcodes(ceps, target)

        table = mongo.correlation_table

        cursor = mongo.count_restaurant_openings_by_year

        percentual = mongo.percent_active_companies

        sheet.add_row ["Porcentagem de empresas ativas", "CEPs próximos a #{target}", "", "Quantidade de aberturas anuais"], style: centered_style
        sheet.add_row ["#{percentual}%", nearby_zipcodes_count, "", "Ano", "Quantidade"], style: centered_style
        cursor.each do |document|
          year = document['_id']
          count = document['count']
          sheet.add_row [ "", "", "", year, count], style: centered_style
        end
        sheet.add_row [], style: centered_style

        sheet.add_row [ "Tabela de correlação", ], style: centered_style
        sheet.add_row ["CNAE fiscal principal", "CNAE fiscal secundária"], style: centered_style
        table.each do |row|
          primary_cnae = row['_id']['CNAE FISCAL PRINCIPAL']
          secondary_cnae = row['_id']['CNAE FISCAL SECUNDARIA']
          sheet.add_row [primary_cnae, secondary_cnae], style: centered_style
        end
      end
      puts "arquivo #{filename} criado."
      wk.serialize("./exports/#{filename}.xlsx")

    end
end

def create_csv(mongo)
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

end

