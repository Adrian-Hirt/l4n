module Queries::Tournament::Team
  class FetchAccessibleBy < Inquery::Query
    schema3 do
      obj! :user
    end

    def call
      ::Tournament::Team.all
    end
  end
end
