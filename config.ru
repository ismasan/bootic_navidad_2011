require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require File.dirname(__FILE__) + '/serializer'

class Site < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/public'
  set :root, File.dirname(__FILE__)

  PRODUCTS = YAML.load_file('products.yml')

  get '/?' do
    cache_long
    @products = PRODUCTS
    erb :index
  end

  SECRET = (ENV['BOOTIC_RESIZE_SECRET'] || File.read('secret.txt').chomp)

  helpers do

    def cache_long(seconds = 3600)
      response['Cache-Control'] = "public, max-age=#{seconds.to_i}"
    end

    def rotate
      %(style="-webkit-transform:rotate(#{(rand*10).to_i-5}deg);")
    end

    def image(shop_id, product, size = '200x200#')

      image_path = product['img_hash'] || Serializer.encode(
        :shop_id => shop_id,
        :g => size,
        :f => product['img']
      )

      url = "http://static.bootic.net/r/#{image_path}"
      digest = Serializer.asset_key(image_path, SECRET)
      url << "?k=#{digest}"
      url

    end

  end

end

run Site
