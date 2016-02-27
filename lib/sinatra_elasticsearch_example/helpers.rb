module SinatraElasticsearchExample
  module Helpers
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
  end
end
