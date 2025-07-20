require 'sinatra'

set :environment, :production
set :accounts, {}

post '/reset' do
  settings.accounts.clear
  'OK'
end

get '/balance' do
  ''
end

post '/event' do
  json_params = JSON.parse(request.body.read)
  event_type = json_params['type']

  if event_type == 'deposit'
    destination = json_params['destination']
    amount = json_params['amount'].to_i

    settings.accounts[destination] ||= 0
    settings.accounts[destination] += amount

    status 201
    return {"destination": {"id": destination, "balance": settings.accounts[destination]}}.to_json

  elsif event_type == 'withdraw'
    origin = json_params['origin']
    amount = json_params['amount'].to_i

    if !settings.accounts.key?(origin)
      status 404
      return '0'
    end

    settings.accounts[origin] -= amount
    status 201
    return {"origin": {"id": origin, "balance": settings.accounts[origin]}}.to_json
  elsif event_type == 'transfer'
    origin = json_params['origin']
    amount = json_params['amount'].to_i
    destination = json_params['destination']

    if !settings.accounts.key?(origin)
      status 404
      return '0'
    end

    settings.accounts[origin] -= amount
    settings.accounts[destination] ||= 0
    settings.accounts[destination] += amount
    status 201
    return {"origin": {"id": origin, "balance": settings.accounts[origin]}, "destination": {"id": destination, "balance": settings.accounts[destination]}}.to_json  

  else
    status 400
    return 'Invalid event type'
  end
end
