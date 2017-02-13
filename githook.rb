#
### repo_permissions_hook.rb
#
### Sinatra-based Ruby API bridge/webhook to set default permissions on all new GitHub repos
# This can be used in the future to migrate repos between On-prem and Azure-based GHE
#
# GitHub API reference can be found here - https://developer.github.com/v3/enterprise/
#

require 'sinatra'
require 'json'
require 'uri'
require 'net/http'

post '/payload' do
  push = JSON.parse(request.body.read)
  puts "I got some JSON: #{push.inspect}"

  if push["action"] == "created"
  	response = APIHelper.add_gherepoadmin(push["repository"]["name"]) 
  	puts response
  end
end

module APIHelper
	
	$github_url =
	$auth = 
	$cache_opt = 'no-cache'
	$org = 'yammer'

	#PUT request to add admin team w/ admin privileges
	def self.add_gherepoadmin(repository)

		teamid = "3"
		url = URI("#{$github_url}/api/v3/teams/#{teamid}/repos/#{$org}/#{repository}")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		add_team = Net::HTTP::Put.new(url)
		add_team["authorization"] = $auth
		add_team["cache-control"] = $cache_opt
		add_team.body = "{\n    \"permission\": \"admin\"\n}"

		response = http.request(add_team)
		puts response.read_body

	end

	#PUT request to add eng team w/ write privs
	def self.add_eng(repository)
		
		teamid = "1"
		url = URI("#{$github_url}/api/v3/teams/#{teamid}/repos/#{$org}/#{repository}")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		add_team = Net::HTTP::Put.new(url)
		add_team["authorization"] = $auth
		add_team["cache-control"] = $cache_opt
		add_team.body = "{\n    \"permission\": \"write\"\n}"

		response = http.request(add_add_team)
		puts response.read_body

	end

end
