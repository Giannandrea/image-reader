
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
      
      post '/translation' do
        s_lang = params[:s_lang]
        d_lang = params[:d_lang]
        ocr_text = URI::decode(params[:ocr_text])
        reader = ImageReader::Reader.new
        text = reader.translate_text ocr_text, s_lang, d_lang
        unless text
          halt 404, "error translating text" 
          raise RequestError.new 'not found'
        end
        status 200
        headers "Allow"   => "BREW, POST, GET, PROPFIND, WHEN"
        body "#{URI::encode(text)}"
      end
end
ServerReader.run! :host => 'localhost', :port => 3000, :server => 'thin', daemonize: true
