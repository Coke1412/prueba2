require 'uri'
require 'net/http'
require 'json'
require_relative 'helperprueba'

#url: https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos
#api_key: 1Jpo96G8z2XXKmIGheqKHrVaJuu5IWJw8J7p6jMd^C


def request(url, api_key)
    
    url = URI("#{url}?sol=1000&api_key=#{api_key}")
    
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    json_response = JSON.parse(response.read_body)
    
end

def build_web_page
    
    url = ARGV[0]
    api_key = ARGV[1]
    data = request(url, api_key)

    File.open('nasapage.html', 'w') do |f|
        f.puts head
        data['photos'].each do |img|
            f.puts "<li><img src='#{img["img_src"]}'></li>"
        end
        f.puts footer
        
        
    end
    

end

build_web_page

def photos_count
    data = request(ARGV[0], ARGV[1])
    camera_count = {}

    data["photos"].each do |image|
        if camera_count[image["camera"]["name"]]
            camera_count[image["camera"]["name"]] = camera_count[image["camera"]["name"]] + 1
        else
            camera_count[image["camera"]["name"]] = 1
        end
    end
        puts camera_count

end

photos_count


