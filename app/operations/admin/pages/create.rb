module Operations::Admin::Pages
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :page do
        str! :title
        str! :published, format: :boolean
        str? :content
        str! :url
      end
    end

    model ::Page
  end
end
