module Queries::MenuItem
  class FindActiveTopElements < Inquery::Query
    def call
      ::MenuItem.where(parent_id: nil).order(sort: :asc)
    end
  end
end
