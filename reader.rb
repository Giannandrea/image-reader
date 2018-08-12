require "./lib/multi-translator.rb"
require "./lib/multi-converter.rb"
require "colorize"
require "json"

CONF_FILE = "config.json"

LANG_CONVERTER = {"ar" => "ara", "bg" => "bul", "ch" => "chs", "hr" => "hrv", "cs" => "cze",
                  "da" => "dan", "nl" => "dut", "en" => "eng", "fi" => "fin", "fr" => "fre", "de" => "ger",
                  "el" => "gre", "hu" => "hun", "ko" => "kor", "it" => "ita", "jp" => "jpn", "no" => "nor",
                  "pl" => "pol", "pt" => "por", "ru" => "rus", "sl" => "slv", "es" => "spa", "sw" => "swe",
                  "tr" => "tur"}

def convertImageToText(file, s_lang)
  mconverter_conf = read_conf_file("multi-converter")
  m_converter = MultiConverter::Converter.new(mconverter_conf)
  m_converter.imageToText(file, s_lang)
end

def translate_text(text, from_lang, to_lang)
  mtranslator_conf = read_conf_file("multi-translator")
  m_translator = MultiTranslator::Translator.new(mtranslator_conf)
  m_translator.translation(text, from_lang, to_lang)
end

def read_conf_file(section)
  file = File.read(CONF_FILE)
  data_hash = JSON.parse(file)
  data_hash[section]
end

file = ARGV[0]
s_lang = ARGV[1]
d_lang = ARGV[2]

puts "                                           ".colorize(:color => :light_white, :background => :blue)
puts "  Convert image to text using language #{s_lang}  ".colorize(:color => :light_white, :background => :blue)
puts "                                           ".colorize(:color => :light_white, :background => :blue)
text = convertImageToText file, s_lang
puts text
puts ""
puts "                                                ".colorize(:color => :light_white, :background => :blue)
puts "  Translate text on the image from #{s_lang} to #{d_lang}     ".colorize(:color => :light_white, :background => :blue)
puts "                                                ".colorize(:color => :light_white, :background => :blue)
translated_text = translate_text(text, s_lang, d_lang)
puts translated_text
puts ""
