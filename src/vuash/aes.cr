require "secure_random"
require "openssl/cipher"
require "json"

module Vuash::AES
  extend self

  CIPHER = "aes-256-cbc"

  def encrypt(message, secret)
    cipher = OpenSSL::Cipher.new(CIPHER)
    cipher.encrypt
    cipher.key = secret
    iv = cipher.random_iv
    encrypted_update = cipher.update(message)
    encrypted_final = cipher.final
    encrypted_data = String.new(encrypted_update)
    encrypted_data += String.new(encrypted_final)

    "#{Base64.strict_encode(encrypted_data)}#{Base64.strict_encode(iv)}"
  end

  def decrypt(message, secret)
    cipher = OpenSSL::Cipher.new(CIPHER)
    encrypted_data, iv = split(message).map { |v| Base64.decode(v) }

    cipher.decrypt
    cipher.key = secret
    cipher.iv = iv
    decrypted_update = cipher.update(encrypted_data)
    decrypted_final = cipher.final
    "#{String.new(decrypted_update)}#{String.new(decrypted_final)}"
  end

  private def split(message)
    {message[0..-25], message[-24..-1]}
  end
end
