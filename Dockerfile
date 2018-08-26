FROM alpine:3.8

RUN apk add --update ruby ruby-dev tesseract-ocr imagemagick build-base libmagic zlib ruby-nokogiri zlib-dev && mkdir /app
RUN gem install unf_ext --no-ri --no-rdoc
ADD . /app
RUN cd /app && gem install --no-ri --no-rdoc bundler && bundle install

EXPOSE 3000

CMD ["ruby", "server/server.rb"]