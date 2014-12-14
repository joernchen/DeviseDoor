require 'active_support'
require 'base64'
secret = "12IO0nCNPFhWz7a56rmhkiIQ8BOgbUw7yIYl++jYNkxAseBT3Q02N+CwShuqDBqY"
keygen = ActiveSupport::KeyGenerator.new(secret,{:iterations => 1337})
enckey = keygen.generate_key('encrypted hacker')
sigkey = keygen.generate_key('signed encrypted hacker')
crypter = ActiveSupport::MessageEncryptor.new(enckey, sigkey,{:serializer => ActiveSupport::MessageEncryptor::NullSerializer })
puts crypter.decrypt_and_verify(ARGV[0])
