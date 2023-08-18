FROM ruby:3.1.3

WORKDIR /application

# Copie os arquivos do aplicativo para o contêiner
COPY /application /application

# Instale as dependências do sistema necessárias para o aplicativo Rails
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Instale as dependências do Ruby necessárias para o aplicativo Rails
RUN gem install bundler
RUN bundle install --jobs 4

# Exponha a porta em que o aplicativo estará em execução
EXPOSE 3001

# Defina o comando de inicialização padrão para o aplicativo
CMD ["bundle", "exec", "ruby", "server.rb", "3001", "production"]
