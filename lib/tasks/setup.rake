namespace :setup do
  desc 'TODO'
  task user: :environment do
    Operations::Setup::User.run
  end
end
