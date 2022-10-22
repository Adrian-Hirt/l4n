module Operations::Admin::FeatureFlag
  class Toggle < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
    end

    model ::FeatureFlag

    def perform
      # Update the db value
      model.toggle(:enabled)
      model.save

      # Update the cache
      Rails.cache.write("feature_flag/#{model.key}", model.reload.enabled?)
    end
  end
end
