class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.validates_translated(attribute, **validations)
    I18n.available_locales.each do |locale|
      validates "#{attribute}_#{locale}", validations
    end
  end

  def self.validates_boolean(attribute, **options)
    validates attribute, inclusion: [true, false], **options
  end

  def self.translate_enums
    defined_enums.each_key do |key|
      define_method "humanized_#{key}" do
        return _("#{self.class.name}|#{key}|#{send(key)}")
      end
    end
  end
end
