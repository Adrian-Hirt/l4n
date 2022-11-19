module Operations::Admin::StartpageBlock
  class Create < RailsOps::Operation::Model::Create
    schema3 do
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
