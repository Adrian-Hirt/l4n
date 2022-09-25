module Operations::Admin::FeatureFlag
  class Toggle < RailsOps::Operation::Model::Update
    schema do
      req :id
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
