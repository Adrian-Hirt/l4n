module Operations::Admin::StartpageBanner
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :startpage_banner do
        str? :name
        str? :height
        str? :visible
        obj? :images
      end
    end

    model ::StartpageBanner
  end
end
