
#!/usr/bin/env ruby -I ../lib -I lib
# coding: utf-8
require 'sinatra'
require 'uri'
paths = File.expand_path(File.dirname(__FILE__)).split("/")
base_dir = paths.reverse.drop(1).reverse
reader_path = base_dir.join("/") + "/reader.rb"
require reader_path
#        body "#{URI::encode(text)}"
class ServerReader < Sinatra::Base
    get '/' do
        erb :form
    end
      
     post '/convert_image' do
        filename = params[:file][:filename]
        file = params[:file][:tempfile]
        filepath = "/tmp/#{filename}"
        File.open(filepath, 'wb') do |f|
          f.write(file.read)
        end
        s_lang = params[:s_lang]
        d_lang = params[:d_lang]
        reader = ImageReader::Reader.new
        text = reader.convertImageToText filepath, s_lang
        status 200
        headers "Allow"   => "BREW, POST, GET, PROPFIND, WHEN"
        body "#{URI::encode(text)}"
      end
      
      get '/not_found' do
        raise RequestError.new 'not found', 404
      end
      
      get '/halt' do
        halt 200, "everything's fine"
        raise RequestError.new "won't get here"
      end

end
ServerReader.run! :host => 'localhost', :port => 3000, :server => 'thin'