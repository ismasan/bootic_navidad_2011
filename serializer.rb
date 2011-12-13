require 'base64'
module Serializer
  
  # Exceptions
  class BadString < RuntimeError; end
  
  extend self # So we can do Serializer.b64_encode, etc.
  
  def b64_encode(string)
    Base64.encode64(string).tr("\n=",'')
  end
  
  def b64_decode(string)
    padding_length = string.length % 4
    Base64.decode64(string + '=' * padding_length)
  end
  
  def encode(object)
    b64_encode(Marshal.dump(object))
  end
  
  def decode(string)
    Marshal.load(b64_decode(string))
  rescue TypeError, ArgumentError => e
    raise BadString, "couldn't decode #{string} - got #{e}"
  end
  
  def asset_key(url, secret)
    Digest::SHA256.hexdigest([url,secret].join)[0..14]
  end
  
end