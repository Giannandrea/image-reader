require "colorize"
paths = File.expand_path(File.dirname(__FILE__)).split("/")
base_dir = paths.reverse.drop(1).reverse
reader_path = base_dir.join("/") + "/reader.rb"
require reader_path

file = ARGV[0]
s_lang = ARGV[1]
d_lang = ARGV[2]

reader = ImageReader::Reader.new

puts "                                           ".colorize(:color => :light_white, :background => :blue)
puts "  Convert image to text using language #{s_lang}  ".colorize(:color => :light_white, :background => :blue)
puts "                                           ".colorize(:color => :light_white, :background => :blue)
text = reader.convertImageToText file, s_lang
puts text
puts ""
puts "                                                ".colorize(:color => :light_white, :background => :blue)
puts "  Translate text on the image from #{s_lang} to #{d_lang}     ".colorize(:color => :light_white, :background => :blue)
puts "                                                ".colorize(:color => :light_white, :background => :blue)
translated_text = reader.translate_text(text, s_lang, d_lang)
puts translated_text
puts ""
