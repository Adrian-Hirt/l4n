module Operations::Admin::FooterLogo
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :footer_logo do
        str? :sort
        str? :visible
        obj? :file
        str? :link
      end
    end

    model ::FooterLogo
  end
end
