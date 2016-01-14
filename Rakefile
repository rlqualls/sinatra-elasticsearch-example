require "elasticsearch"
require "fileutils"
require "curb"

# Note: It says 'countries' but it's a movie title data set

def download(url, filename)
  easy = Curl::Easy.new
  easy.follow_location = true
  easy.url = url
  print "'#{url}' :"

  File.open(filename, 'wb') do |f|
    easy.on_progress do |dl_total, dl_now, ul_total, ul_now|
      print "="
      true
    end
    easy.on_body { |data| f << data; data.size }
    easy.perform
    puts "=> '#{filename}'"
  end
end

task :download do
  filename = "countries.list.gz"
  if not File.exist? 'countries.list'
    download "ftp://ftp.fu-berlin.de/pub/misc/movies/database/#{filename}", filename
    `gunzip countries.list.gz`
  end
end

task :convert do
  puts "Converting the data to UTF-8..."
  `iconv -f WINDOWS-1252 -t UTF-8 countries.list > countries.list.utf8`
end

task :strip do
    puts "Removing duplicates..."
    movies = []

    File.open("countries.list.utf8").each_line do |line|
      matches = line.match(/\"(.*)\"/)
      name = matches.captures.first if matches
      movies << name.to_s
    end

    movies = movies.uniq

    File.open("movies.dat", "w") do |file|
      movies.each do |movie|
        file.puts movie
      end
    end
end

task :elastic do
  puts "Putting the data into elasticsearch..."

  client = Elasticsearch::Client.new
  id = 1

  File.open('movies.dat').each_line do |line|
    if line.match(/\w/)
      client.index  index: 'imdb', type: 'movie', id: id, body: { title: line.chomp }
      id += 1

      puts "#{id} movies processed" if id % 10000 == 0
    end
  end
end

task :setup => [:download, :convert, :strip, :elastic] do
  puts "Ready, just \"rackup\""
end
