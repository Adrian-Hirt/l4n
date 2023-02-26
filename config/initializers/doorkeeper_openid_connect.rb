def issuer_string
  @issuer_string ||= if Rails.env.development?
                       'http://localhost:3000/'
                     else
                       "https://#{Figaro.env.application_domain}/"
                     end
end

Doorkeeper::OpenidConnect.configure do
  issuer issuer_string

  signing_key Figaro.env.oidc_rsa_private_key

  subject_types_supported [:public]

  resource_owner_from_access_token do |access_token|
    User.find_by(id: access_token.resource_owner_id)
  end

  subject do |resource_owner, _application|
    resource_owner.id
  end

  auth_time_from_resource_owner do |_resource_owner|
    nil
  end

  claims do
    # rubocop:disable Style/SymbolProc
    claim :username, response: %i[id_token user_info], scope: :openid do |resource_owner|
      resource_owner.username
    end
    # rubocop:enable Style/SymbolProc
  end
end
