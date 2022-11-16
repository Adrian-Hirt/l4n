module Operations::Admin::StartpageBanner
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :startpage_banner do
        str? :name
        str? :height
        str? :visible
        obj? :images
        obj? :remove_images
      end
    end

    model ::StartpageBanner do
      attribute :remove_images
    end

    def perform
      super

      return unless model.valid?

      osparams.startpage_banner[:remove_images]&.each do |id_to_remove|
        model.images.find(id_to_remove).purge
      end
    end
  end
end
