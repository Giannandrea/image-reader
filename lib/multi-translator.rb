require "ps_yandex_translator"
#equire "microsoft_translator"
require "watson-language-translator"
require "rest-client"
require "wtf_lang"

module MultiTranslator
  class Translator
    def initialize(mtranslator_config)
      WtfLang::API.key = mtranslator_config["wtf_lang"]["wtf_lang_key"]
      YandexTranslator::Api.conf do |params|
        params.api_key = mtranslator_config["yandex"]["api_key"]
        params.default_lang = mtranslator_config["yandex"]["default_lang"]
      end

      ENV["language_translator_username"] = mtranslator_config["watson"]["language_translator_username"]
      ENV["langauge_translator_password"] = mtranslator_config["watson"]["langauge_translator_password"]
      #microsoft_translator = MicrosoftTranslator::Client.new("your_client_id", "your_client_secret")
      return self
    end

    def identifyLanguage(text)
      identify = text.lang_confidence
      return nil if identify.last < 0.6
      identify.first
    end

    def watsonTranslation(text, s_lang, d_lang)
      j_result = WatsonLanguage::Translator.new(text, source: s_lang, target: d_lang, http_method: "post")
      res = j_result.result  # => {"translations"=>[{"translation"=>"Hola"}], "word_count"=>1, "character_count"=>5}
      res["translations"].first["translation"]
    end

    def yandexTranslation(text, s_lang, d_lang)
      YandexTranslator::Api.define_language(text: text)
      result = YandexTranslator::Api.translate(text: text, lang: d_lang)
      result
    end

    def translation(text, s_lang, d_lang)
      ran = Random.rand(2)
      #if ran == 1
      res = yandexTranslation(text, s_lang, d_lang)
      #else
      #res = watsonTranslation(text, s_lang, d_lang)
      #end
      res
    end
  end
end
