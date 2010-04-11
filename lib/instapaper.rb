require 'net/http'
require 'net/https'
require 'cgi'

class Instapaper
  def self.add_url(username, url, password)
    encoded_url = CGI.escape(url)

    http = Net::HTTP.new('www.instapaper.com', 443)
    http.use_ssl = true
    path = '/api/add'
    data = "username=#{username}&password=#{password}&url=#{encoded_url}"

    resp, data = http.post(path, data)
  end
end
