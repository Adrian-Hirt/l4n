module ProductBehaviours
  extend ActiveSupport::Concern

  def enabled_product_behaviour_classes
    behaviours = []

    enabled_product_behaviours&.each do |behaviour_string|
      behaviours << self.class.resolve_behaviour(behaviour_string)
    end

    behaviours
  end

  def enabled_product_behaviours=(enabled_behaviours)
    self[:enabled_product_behaviours] = enabled_behaviours.compact_blank
  end

  def execute_behaviours(order_item: nil)
    enabled_product_behaviour_classes.each do |behaviour|
      behaviour.run(product: self, order_item: order_item)
    end
  end

  def validate_behaviours
    enabled_product_behaviour_classes.each do |behaviour|
      behaviour.run_validations(self)
    end
  end

  def available_product_behaviours
    self.class.registered_keys.map { |key| [key.to_s, _("ProductBehaviours|#{key.capitalize}")] }
  end

  class_methods do
    def register_behaviour(key, behaviour_class)
      registry[key] = behaviour_class
    end

    def resolve_behaviour(behaviour_string)
      resolved = registry[behaviour_string.to_sym]
      fail 'Not resolvable' if resolved.nil?

      resolved
    end

    def registered_keys
      registry.keys
    end
  end

  included do
    # Registry to hold the behaviours
    cattr_accessor(:registry) { {} }

    # Serialize the enabled product behaviours
    serialize :enabled_product_behaviours, Array

    # We want to run the behaviour validations after the normal validations
    after_validation :validate_behaviours
  end
end
