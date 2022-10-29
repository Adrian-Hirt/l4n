module Operations::Admin::Pages
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      str! :id, format: :integer
      hsh? :page do
        str? :title
        boo? :published, cast_str: true
        str? :content
        str? :url
        boo? :use_sidebar, cast_str: true
      end
    end

    model ::Page
  end
end
