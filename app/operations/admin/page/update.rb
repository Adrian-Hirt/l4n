module Operations::Admin::Page
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      str! :id, format: :integer
      hsh? :content_page do
        str? :title
        boo? :published, cast_str: true
        str? :content
        str? :url
        boo? :use_sidebar, cast_str: true
      end
      hsh? :redirect_page do
        str? :url
        str? :redirects_to
      end
    end

    model ::Page

    # Needed as default find_model does not work with STI
    def find_model
      fail "Param #{model_id_field.inspect} must be given." unless params[model_id_field]

      # Get model class
      relation = Page

      # Express intention to lock if required
      relation = relation.lock if self.class.lock_model_at_build?

      # Fetch (and possibly lock) model
      relation.find_by!(model_id_field => params[model_id_field])
    end
  end
end
