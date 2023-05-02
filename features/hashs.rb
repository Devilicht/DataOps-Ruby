require_relative '../db/mongo.rb'

def create_hashes
  mongo = MongoInfoCompanies.new

    Dir.glob('./DataCNPJ/unzipped/*.ESTABELE') do |filename|
      CSV.foreach(filename, encoding: 'ISO-8859-1', col_sep: ';', headers: true) do |row|

        hash = {
          "CNPJ BÁSICO" => row[0],
          "CNPJ ORDEM" => row[1],
          "CNPJ DV" => row[2]&.strip,
          "IDENTIFICADOR MATRIZ/FILI1AL" => row[3],
          "NOME FANTASIA" => row[4],
          "SITUAÇÃO CADASTRAL" => row[5],
          "DATA SITUAÇÃO CADASTRAL" => row[6],
          "MOTIVO SITUAÇÃO CADASTRAL" => row[7],
          "NOME DA CIDADE NO EXTERIOR" => row[8],
          "PAIS" => row[9],
          "DATA DE INICIO DA ATIVIDADE" => row[10],
          "CNAE FISCAL PRINCIPAL" => row[11],
          "CNAE FISCAL SECUNDARIA" => row[12],
          "TIPO DE LOGRADOURO" => row[13],
          "LOGADOURO" => row[14],
          "NUMERO" => row[15],
          "COMPLEMENTO" => row[16],
          "BAIRRO" => row[17],
          "CEP" => row[18],
          "UF" => row[19],
          "MUNICIPIO" => row[20],
          "DDD1" => row[21],
          "TELEFONE 1" => row[22],
          "DDD2" => row[23],
          "TELEFONE 2" => row[24],
          "DDD DO FAX" => row[25],
          "FAX" => row[26],
          "CORREIO ELETRONICO" => row[27],
          "SITUAÇÃO ESPECIAL" => row[28],
          "DATA SITUAÇÃO ESPECIAL" => row[29]
        }
        mongo.add_company(hash)
      end
    end
  end
