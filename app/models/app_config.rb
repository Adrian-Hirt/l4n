# RailsSettings Model
class AppConfig < RailsSettings::Base
  cache_prefix { 'v1' }

  scope :application do
    field :application_name, default: 'L4N', validates: { presence: true, length: { in: 2..20 } }
  end

  scope :sidebar do
    field :enable_lan_party_block, default: false, validates: { inclusion: [true, false] }
    field :enable_events_block, default: false, validates: { inclusion: [true, false] }
    field :enable_news_block, default: false, validates: { inclusion: [true, false] }
  end
end
