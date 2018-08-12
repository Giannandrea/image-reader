require "./lib/multi-translator.rb"
require "./lib/multi-converter.rb"
require "json"

LANG_CONVERTER = {"ar" => "ara", "bg" => "bul", "ch" => "chs", "hr" => "hrv", "cs" => "cze",
                  "da" => "dan", "nl" => "dut", "en" => "eng", "fi" => "fin", "fr" => "fre", "de" => "ger",
                  "el" => "gre", "hu" => "hun", "ko" => "kor", "it" => "ita", "jp" => "jpn", "no" => "nor",
                  "pl" => "pol", "pt" => "por", "ru" => "rus", "sl" => "slv", "es" => "spa", "sw" => "swe",
                  "tr" => "tur"}

module ImageReader
  class Reader
    CONF_FILE = "config.json"

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
  end
end
