FROM jekyll/builder AS builder

WORKDIR /srv/jekyll

COPY Gemfile Gemfile*.lock ./

RUN gem install bundler:1.17.2

RUN bundle install

COPY . .

ENV JEKYLL_ENV=development

RUN jekyll build && cp -r ./_site /build

FROM nginx:alpine AS nginx

COPY --from=builder /build /usr/share/nginx/html

EXPOSE 80
