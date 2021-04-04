namespace :sessions do
  task expire_old: :environment do
    Operations::Session::ExpireOld.run
  end
end
