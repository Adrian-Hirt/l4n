module Queries::Tournament::Match
  class FetchAccessibleBy < Inquery::Query
    schema3 do
      obj! :user
    end

    def call
      ::Tournament::Match.all
    end
  end
end
