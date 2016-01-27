require 'openssl'

class CommonController < ApplicationController
  # GET /common/sshkeygen
  def sshkeygen
    key = OpenSSL::PKey::RSA.new 2048
    public_key = key.public_key.to_s.delete "\n"
    public_key = public_key.gsub "-----BEGIN PUBLIC KEY-----", "ssh-rsa "
    public_key = public_key.gsub "-----END PUBLIC KEY-----", " oh-my-cluster\n"
    data = {:private => key.to_pem, :public => public_key}
    render json: data
  end
end
