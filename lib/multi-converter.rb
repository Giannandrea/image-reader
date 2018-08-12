require "httmultiparty"
require "google_spellcheck"
#include HTTMultiParty

DEFAULT_LANGUAGE = "eng"

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

    def check_text(text)
      corrected_txt = GoogleSpellcheck.run(text)
      if !corrected_txt
        return false
      elsif corrected_txt == true
        return text
      end
      corrected_txt
    end

    def imageToTextOcrSpace(file, lang)
      lang ||= DEFAULT_LANGUAGE
      file_descriptor = File.new(file)
      body_ocr = {apikey: @ocr_api_key, language: lang, isOverlayRequired: true, file: file_descriptor}
      data = HTTParty.post(@ocr_api_url, body: body_ocr)
    end

    def imageToText(file, lang = nil)
      lang = LANG_CONVERTER[lang] if lang
      response = imageToTextOcrSpace(file, lang)
      result_text = isGood(response)
      good_text = check_text(result_text) if result_text
      return_text = ""
      good_text.split("\n").each { |line|
        return_text += line + "\n"
      }
      return_text
    end
  end
end
