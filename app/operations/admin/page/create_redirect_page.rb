module Operations::Admin::Page
  class CreateRedirectPage < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :redirect_page do
        str? :url
        str? :redirects_to
      end
    end

    model ::RedirectPage
  end
end
