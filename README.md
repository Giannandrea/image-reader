# image-reader


## Introduction

Currenlty this project provides a simple application and able to read the text in an image import it and next traslate it a language. 
The key point of this application is the ability to use multiple trasnlator and converter provider. 

## Installation
    git clone https://github.com/Giannandrea/image-reader.git
    cd image-reader
    bundle install
    
## supported services
- ocr.space (https://ocr.space/ocrapi)
- Yandex translator (https://tech.yandex.com/translate/)
- Watson translator (https://www.ibm.com/watson/services/language-translator/

## Usage
    ruby bin/run.rb <image> <source language> <destination language>
    # example
    ruby bin/run.rb example.jpg nl en

## Supported Languages
- Arabic => "ar"
- Bulgrian => "bg"
- Danish => "da"
- Croatian => "hr"
- Nederlands => "nl"
- English => "en"
- Finland => "fi"
- Greek => "el"
- Hungherian => "hu"
- korean => "ko"
- Italian => "it"
- Japanese => "jp"
- Norvegian => "no"
- German => "de"
- French => "fr"
- Polish => "pl"
- Portuguese => "pt"
- Russian => "ru"
- Slovenian => "sl"
- Spanish => "es"
- Turkish => "tr"

## License

This module is released under the MIT license.

## Bugs

See <https://github.com/Giannandrea/image-reader/issues>.
