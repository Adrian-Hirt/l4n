class Order < ApplicationRecord
  ################################### Attributes ###################################
  enum status: {
    created:         'created',
    payment_pending: 'payment_pending',
    paid:            'paid',
    aborted:         'aborted',
    completed:       'completed'
  }
  ################################### Constants ####################################
  TIMEOUT = 15.minutes
  TIMEOUT_IN_PAYMENT = 30.minutes

  ################################### Associations #################################
  belongs_to :user
  has_many :order_items, dependent: :destroy

  ################################### Validations ##################################

  ################################### Hooks ########################################

  ################################### Scopes #######################################

  ################################### Class Methods ################################

  ################################### Instance Methods #############################
  def encrypted_base64_id
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31])
    encrypted_id = crypt.encrypt_and_sign(id)
    Base64.urlsafe_encode64(encrypted_id)
  end

  ################################### Private Methods ##############################
end
