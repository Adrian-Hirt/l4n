module Operations::Admin::Pages
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      str! :id, format: :integer
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
