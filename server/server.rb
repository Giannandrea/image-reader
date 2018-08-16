
#!/usr/bin/env ruby
$:.unshift File.expand_path '../../../lib', __FILE__

require 'angelo'
require 'openssl'


paths = File.expand_path(File.dirname(__FILE__)).split("/")
base_dir = paths.reverse.drop(1).reverse
reader_path = base_dir.join("/") + "/reader.rb"
require reader_path

class ServerReader < Angelo::Base
    HEART = '<3'
    CORS = { 'Access-Control-Allow-Origin' => '*',
             'Access-Control-Allow-Methods' => 'GET, POST'}
  
    addr '0.0.0.0'
    port 3000
    ping_time 3
    report_errors!
    log_level Logger::INFO
  
    @@hearting = false
    @@beating = false

    views_dir 'views/'

    get '/' do
        erb :form
    end
      
     post '/convert_image' do
        #raise RequestError.new '"source lang" and "destination lang" is a required parameter' if !params[:s_lang] or !params[:s_lang]
        puts "post ok"
        @filename = params[:file][:filename]
        file = params[:file][:tempfile]
        f = File.open("/tmp/tmp_imge.pdf","wb")
        f.write(file)
        halt 200, "everything's fine s_lang: #{params[:s_lang]}, d_lang: #{params[:d_lang]}"
      end
      
      get '/not_found' do
        raise RequestError.new 'not found', 404
      end
      
      get '/halt' do
        halt 200, "everything's fine"
        raise RequestError.new "won't get here"
      end

end

ServerReader.run!