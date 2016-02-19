require "elasticsearch"
require "fileutils"
require "tty-spinner"
require "curb"

# Note: It says 'countries' but it's a movie title data set

def download(url, filename)
  easy = Curl::Easy.new
  easy.follow_location = true
  easy.url = url

  File.open(filename, 'wb') do |f|
    spinner = TTY::Spinner.new("Dowloading #{url}... ", format: :spin_4)
    easy.on_progress do |dl_total, dl_now, ul_total, ul_now|
      spinner.spin
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
    `gunzip #{filename}`
  end
end

task :convert do
  filename = "countries.list.utf8"
  if not File.exist? filename
    puts "Converting the data to UTF-8..."
    `iconv -f WINDOWS-1252 -t UTF-8 countries.list > #{filename}`
  end
end

task :strip do
  filename = "movies.dat"
  if not File.exist? filename
    puts "Removing duplicates..."
    movies = []

    File.open("countries.list.utf8").each_line do |line|
      matches = line.match(/\"(.*)\"/)
      name = matches.captures.first if matches
      movies << name.to_s
    end

    movies = movies.uniq

    File.open(filename, "w") do |file|
      movies.each do |movie|
        file.puts movie
      end
    end
  end
end

task :elastic do
  puts "Putting the data into elasticsearch...this could take 1-5 minutes"

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
