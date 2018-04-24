FROM ruby:2.3.1-onbuild
VOLUME /usr/src/app/source
EXPOSE 4567

# ENV http_proxy http://gateway.bns:8000
# ENV https_proxy http://gateway.bns:8000

RUN apt-get update && apt-get install -y nodejs \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["bundle", "exec", "middleman", "server", "--watcher-force-polling"]