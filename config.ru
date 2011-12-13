require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require File.dirname(__FILE__) + '/serializer'

class Site < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/public'
  set :root, File.dirname(__FILE__)
  
  get '/?' do
    cache_long
    erb :index
  end
  
  SECRET = File.read('secret.txt').chomp
  
  helpers do
    
    def cache_long(seconds = 3600)
      response['Cache-Control'] = "public, max-age=#{seconds.to_i}"
    end
    
    def rotate
      %(style="-webkit-transform:rotate(#{ rand * 1 - rand * 1}deg);")
    end
    
    def image(shop_id, file_name, size = '200x200#')
      
      image_path = Serializer.encode(
        :shop_id => shop_id, 
        :g => size, 
        :f => file_name
      )

      url = "http://static.bootic.net/r/#{image_path}"
      digest = Serializer.asset_key(image_path, SECRET)
      url << "?k=#{digest}"
      url
      
    end
    
  end
  
end

run Site