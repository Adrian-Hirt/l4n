class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  MAX_PERMITTED_INT = 2_147_483_647

  def self.validates_translated(attribute, **validations)
    I18n.available_locales.each do |locale|
      validates "#{attribute}_#{locale}", validations
    end
  end

  def self.validates_boolean(attribute, **)
    validates(attribute, inclusion: [true, false], **)
  end

  def self.translate_enums
    defined_enums.each_key do |key|
      define_method :"humanized_#{key}" do
        _("#{self.class.name}|#{key}|#{send(key)}")
      end
    end
  end
end
