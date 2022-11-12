module Operations::Admin::FooterLogo
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::FooterLogo
  end
end
