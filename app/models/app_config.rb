# RailsSettings Model
class AppConfig < RailsSettings::Base
  cache_prefix { 'v1' }

  scope :application do
    field :application_name, default: 'L4N', validates: { presence: true, length: { in: 2..20 } }
  end
end
