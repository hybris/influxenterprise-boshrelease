#!/usr/bin/env ruby

require 'json'
require 'net/http'

def vo_message(status, routes = [])
  {
    message_type: status == :error ? 'CRITICAL' : 'RECOVERY',
    entity_id: "#{ENV['DOMAIN']}.route-checker",
    entity_display_name: 'Not allowed routes detected',
    state_message:
      "The following routes for #{ENV['DOMAIN']} are not allowed: \n#{routes.join("\n")}"
  }.to_json
end

def send_http(uri, message)
  request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
  request.body = message
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.request(request)
end

def send_vo(status, routes = [])
  puts 'Update VictorOps'
  routing_key = ENV['VO_ROUTING_KEY']
  token = ENV['VO_API_KEY']
  uri = URI("https://alert.victorops.com/integrations/generic/20131114/alert/#{token}/#{routing_key}")
  response = send_http(uri, vo_message(status, routes))
  puts "VO notification failed with #{response.body}" if response.code != '200'
end

def login
  puts `cf api #{ENV['CF_API']}`
  puts `cf auth #{ENV['CF_USER']} #{ENV['CF_PASSWORD']}`
end

def get_routes(url)
  puts 'Get routes'
  resp = JSON.parse(`cf curl '#{url}'`)
  apps = resp['resources']
  apps.concat(get_routes(resp['next_url'])) if resp['next_url']
  apps
end

def org_space(url)
  space = JSON.parse(`cf curl '#{url}'`)
  org = JSON.parse(`cf curl '#{space['entity']['organization_url']}'`)
  "org: #{org['entity']['name']} space: #{space['entity']['name']}"
end

allowed_routes = [ENV['ALLOWED_ROUTES'].chomp.split(', ')].flatten
puts "White listed routes: \n#{allowed_routes}"
login
not_allowed_routes =
  get_routes("/v2/routes?q=domain_guid:#{ENV['DOMAIN_GUID']}").collect do |route|
    if(ENV['DELETE_ROUTES'] == "true"  && !allowed_routes.include?(route['entity']['host']))
      `cf curl -X DELETE '#{route['metadata']['url']}?recursive=true'`
    end

    "#{route['entity']['host']} #{org_space(route['entity']['space_url'])}" unless
      allowed_routes.include?(route['entity']['host'])
  end.compact

puts not_allowed_routes

if ENV['DELETE_ROUTES'] != "true"
  if not_allowed_routes.empty?
    send_vo(:ok)
  else
    send_vo(:error, not_allowed_routes)
  end
end
