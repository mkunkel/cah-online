FROM ruby:2.6.5
LABEL service-id=cah-online

RUN apt-get update && apt-get install -y nodejs npm
RUN npm install -g yarn

WORKDIR /code

COPY . /code/

RUN bundle install

EXPOSE 3000

CMD [ "/code/bin/start" ]
