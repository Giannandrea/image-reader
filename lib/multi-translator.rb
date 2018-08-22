require "ps_yandex_translator"
#equire "microsoft_translator"
require "ibm_watson/language_translator_v3"
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

      @language_translator = language_translator = IBMWatson::LanguageTranslatorV3.new(
        version: "2018-05-31",
        username: mtranslator_config["watson"]["language_translator_username"],
        password: mtranslator_config["watson"]["langauge_translator_password"]
      )
      #microsoft_translator = MicrosoftTranslator::Client.new("your_client_id", "your_client_secret")
      return self
    end

    def identifyLanguage(text)
      identify = text.lang_confidence
      return nil if identify.last < 0.6
      identify.first
    end

    def watsonTranslation(text, s_lang, d_lang)
      model = "#{s_lang}-#{d_lang}"
      translation = nil
      mt = @language_translator.translate(text: text, model_id: model).result
      begin
        translation = mt["translations"][0]["translation"]
      rescue
        translation = nil
      end
      return translation
    end

    def yandexTranslation(text, s_lang, d_lang)
      YandexTranslator::Api.define_language(text: text)
      result = YandexTranslator::Api.translate(text: text, lang: d_lang)
      result
    end

    def translation(text, s_lang, d_lang)
      ran = Random.rand(2)
      if ran == 1
        res = watsonTranslation(text, s_lang, d_lang)
      else
        res = yandexTranslation(text, s_lang, d_lang)
      end
      res
    end
  end
end
