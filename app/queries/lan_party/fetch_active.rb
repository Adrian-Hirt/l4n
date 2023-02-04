module Queries::LanParty
  class FetchActive < Inquery::Query
    def call
      ::LanParty.where(active: true).order(sort: :asc)
    end
  end
end
