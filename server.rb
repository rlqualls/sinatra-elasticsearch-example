require 'sinatra'
require 'curb'
require 'json'
# require 'elasticsearch' # breaks server for unknown reason

ELASTIC_HOST = "localhost"
ELASTIC_PORT = 9200

get '/' do
    File.read(File.join('public', 'index.html'))
end

post '/api/movie_search' do
  @title = params[:title]
  result = Curl.get("http://#{ELASTIC_HOST}:#{ELASTIC_PORT}/imdb/movie/_search?q=#{@title}")
  temp_json = JSON.parse result.body_str
  response = []
  temp_json["hits"]["hits"].each do |hit|
    response << hit["_source"]["title"]
  end

  # response.to_json.gsub('\n', '')
  response.to_json
end
