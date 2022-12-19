module Operations::User
  class Autocomplete < RailsOps::Operation
    schema3 do
      str? :q
    end

    policy :on_init do
      authorize! :read, ::User
    end

    attr_accessor :users

    def perform
      sanitized_value = ActiveRecord::Base.sanitize_sql_like(osparams.q.downcase)
      @users = ::User.where('LOWER(username) LIKE ?', "%#{sanitized_value}%").order(:username)
    end
  end
end
