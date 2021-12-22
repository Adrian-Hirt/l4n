class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.validates_translated(attribute, **validations)
    I18n.available_locales.each do |locale|
      validates "#{attribute}_#{locale}", validations
    end
  end
end
