require "httmultiparty"
require "google_spell_checker"
require "rtesseract"
require "mini_magick"
#include HTTMultiParty

DEFAULT_LANGUAGE = "eng"
LANG_CONVERTER_639_2T = {"ar" => "ara", "bg" => "bul", "ch" => "chi_tra", "hr" => "hrv", "cs" => "cze",
  "da" => "dan", "nl" => "nld", "en" => "eng", "fi" => "fin", "fr" => "fra", "de" => "deu",
  "el" => "ell", "hu" => "hun", "ko" => "kor", "it" => "ita", "jp" => "jpn", "no" => "nor",
  "pl" => "pol", "pt" => "por", "ru" => "rus", "sl" => "slv", "es" => "spa", "sw" => "swe",
  "tr" => "tur"}

module MultiConverter
  class Converter
    def initialize(mconverter_config)
      @ocr_api_key = mconverter_config["ocr.space"]["ocr_api_key"]
      @ocr_api_url = mconverter_config["ocr.space"]["ocr_api_url"]
    end

    def parse_converted_result(res)
      text = ""
      res["Lines"].each { |line|
        line["Words"].each { |word|
          text += word["WordText"] + " "
        }
        text += "\n"
      }
      text
    end

    def isGood(result)
      begin
        isErroredOnProcessing = result.parsed_response["IsErroredOnProcessing"]
        res_text = parse_converted_result(result.parsed_response["ParsedResults"][0]["TextOverlay"])
      rescue
        return false
      end
      return res_text
    end

    def check_text(array_text)
      text = array_text.join(" ")
      corrected_txt = GoogleSpellChecker.check(text)
      puts corrected_txt
      if !corrected_txt
        return false
      elsif corrected_txt == true
        return text
      end
      corrected_txt.gsub(/<\/?[^>]*>/, '').gsub(/\n\n+/, "\n").gsub(/^\n|\n$/, '')
    end

    def spell_check(text)
      return_text = ""
      str = []
      text.split(" ").each {|word|
        str << word
        if str.size > 5 or word.include? "."
          correct = check_text str
          str = []
          return_text << correct
        end
      }
      correct = check_text str
      return_text << correct
      return text
    end

    def imageToTextTesseract(file, lang)
      image = RTesseract.new(file, :lang => lang, :processor => "mini_magick")
      begin
        retrn = image.to_s
      rescue
        return nil
      end
      return retrn
    end

    def imageToTextOcrSpace(file, lang)
      lang ||= DEFAULT_LANGUAGE
      file_descriptor = File.new(file)
      body_ocr = {apikey: @ocr_api_key, language: lang, isOverlayRequired: true, file: file_descriptor}
      data = HTTParty.post(@ocr_api_url, body: body_ocr)
    end

    def imageToText(file, lang = nil)
      lang = LANG_CONVERTER_639_2T[lang] if lang
      responseT = imageToTextTesseract(file, lang)
      good_text = responseT.to_s
#      unless good_text
#        response = imageToTextOcrSpace(file, lang)
#        result_text = isGood(response)
#        good_text = spell_check(result_text) if result_text
#      end
      good_text
    end
  end
end
