module Queries::MenuItem
  class FindActiveTopElements < Inquery::Query
    def call
      ::MenuItem.where(parent: nil).order(sort: :asc)
    end
  end
end
