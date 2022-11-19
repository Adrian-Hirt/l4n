module Operations::Admin::StartpageBlock
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :startpage_block do
        str? :visible
        str? :title
        int? :sort, cast_str: true
        str? :content
      end
    end

    model ::StartpageBlock
  end
end
