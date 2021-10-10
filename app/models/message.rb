require "openssl"

class Message < ApplicationRecord
  validates :body, presence: true

  def body
    if self[:body].nil? || self[:body].empty?
      self[:body]
    else
      encoded = self[:body]
      decoded = Base64.decode64 encoded.encode("ASCII-8BIT")
      decipher = OpenSSL::Cipher::AES256.new :CBC
      decipher.decrypt
      decipher.iv = cipher_iv
      decipher.key = cipher_key
      decipher.update(decoded) + decipher.final
    end
  end

  def body=(text)
    if text.nil? || text.empty?
      self[:body] = text
    else
      cipher = OpenSSL::Cipher::AES256.new :CBC
      cipher.encrypt
      cipher.iv = cipher_iv
      cipher.key = cipher_key
      encrypted = cipher.update(text) + cipher.final
      encoded = Base64.encode64(encrypted).encode("UTF-8")
      self[:body] = encoded
    end
  end

  private

  def cipher_key
    ENV["message_cipher_key"].encode("ASCII-8BIT")
  end

  def cipher_iv
    ENV["message_cipher_iv"].encode("ASCII-8BIT")
  end
end
