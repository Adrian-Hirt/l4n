module Operations::Admin::FooterLogo
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
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
