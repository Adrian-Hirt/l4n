module Operations::Admin::Page
  class CreateContentPage < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :content_page do
        str? :title
        boo? :published, cast_str: true
        str? :content
        str? :url
        boo? :use_sidebar, cast_str: true
      end
    end

    model ::ContentPage
  end
end
