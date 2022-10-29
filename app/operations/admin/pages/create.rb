module Operations::Admin::Pages
  class Create < RailsOps::Operation::Model::Create
    schema3 do
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
