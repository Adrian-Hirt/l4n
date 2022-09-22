module Encryptable
  extend ActiveSupport::Concern

  class_methods do
    def encryptable_attribute(name, attributes = nil)
      define_method "encrypted_#{name}" do
        if attributes.nil?
          data = send(name)
        elsif attributes.is_a?(Array)
          data = attributes.map { |attribute| send(attribute) }.join('$')
        elsif respond_to?(attributes)
          data = send(attributes)
        else
          fail "Unknown attribute #{attributes}"
        end

        return self.class.encrypt_data(data)
      end
    end

    def encrypt_data(plaintext)
      len = ActiveSupport::MessageEncryptor.key_len
      secret = ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
      crypt = ActiveSupport::MessageEncryptor.new(secret.first(len))
      crypt.encrypt_and_sign(plaintext)
    end

    def decrypt_data(ciphertext)
      len = ActiveSupport::MessageEncryptor.key_len
      secret = ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
      crypt = ActiveSupport::MessageEncryptor.new(secret.first(len))
      crypt.decrypt_and_verify(ciphertext)
    end
  end
end
