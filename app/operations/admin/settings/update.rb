module Operations::Admin::Settings
  class Update < RailsOps::Operation
    schema3 do
      hsh? :app_config do
        str? :application_name
      end
    end

    policy :on_init do
      authorize! :manage, AppConfig
    end

    def settings
      @settings ||= AppConfig.defined_fields.group_by { |field| field[:scope] }
    end

    def model
      @model ||= AppConfig.new
    end

    def entered_values
      @entered_values ||= {}
    end

    def perform
      ActiveRecord::Base.transaction do
        osparams.app_config.each do |key, value|
          next if value.nil?

          # Remove whitespaces
          value = value.strip

          # This is only for validation
          config = AppConfig.new(var: key)
          config.value = value

          # Bookkeep the entered values
          entered_values[key] = value

          if config.valid?
            AppConfig.send("#{key}=", value.strip)
          else
            model.errors.merge!(config.errors)
          end
        end

        fail RailsOps::Exceptions::ValidationFailed if model.errors.present?
      end
    end
  end
end
