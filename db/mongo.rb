require 'dotenv/load'
require 'mongo'
require_relative '../features/getLocation.rb'


class MongoInfoCompanies
  def initialize
    mongo_url = ENV['MONGO_URL']
    @client = Mongo::Client.new(mongo_url)
    @db = @client.use('infoCompanies')
    @companies = @db[:companies]
  end

  def add_company(company)
    @companies.insert_one(company)
  end

  def add_companies(company_array)
    @companies.insert_many(company_array)
  end

  def count_restaurant_openings_by_year
    restaurant_prefix = '561'
    pipeline = [
      { "$match": { "CNAE FISCAL PRINCIPAL": { "$regex": "^#{restaurant_prefix}" } } },
      { "$group": { "_id": { "$substr": [ "$DATA DE INICIO DA ATIVIDADE", 0, 4 ] }, "count": { "$sum": 1 } } }
    ]
    @companies.aggregate(pipeline)
  end

  def formatted_cep
    get_all_ceps.map { |cep| cep.to_s.rjust(8, '0').insert(5, '-') }
  end


  def percent_active_companies
    total_companies = @companies.count_documents({})
    active_companies = @companies.count_documents({"SITUAÇÃO CADASTRAL": "02"})
    ((active_companies.to_f / total_companies) * 100).round(2)
  end

  def count_restaurant_openings_by_year
    restaurant_prefix = '561'
    pipeline = [
      { "$match": { "CNAE FISCAL PRINCIPAL": { "$regex": "^#{restaurant_prefix}" } } },
      { "$group": { "_id": { "$substr": [ "$DATA DE INICIO DA ATIVIDADE", 0, 4 ] }, "count": { "$sum": 1 } } }
    ]
    @companies.aggregate(pipeline)
  end

  def get_all_ceps
    result = @companies.distinct('CEP')
    return result
  end

  def correlation_table
    pipeline = [
      { "$unwind": "$CNAE FISCAL SECUNDARIA" },
      { "$group": { "_id": { "CNAE FISCAL PRINCIPAL": "$CNAE FISCAL PRINCIPAL", "CNAE FISCAL SECUNDARIA": "$CNAE FISCAL SECUNDARIA" }, "count": { "$sum": 1 } } },
      { "$sort": { "count": -1 } }
    ]
    @companies.aggregate(pipeline)
  end
end
