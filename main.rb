require 'sinatra'

set :environment, :production

@accounts = {}

post '/reset' do
  @accounts = {}
  'OK'
end

post '/balance' do
  ''
end

post '/event' do
  ''
end
