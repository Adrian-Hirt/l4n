# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
#
# run `whenever --update-crontab` to install the crontabs

set :output, "#{Whenever.path}/log/cron.log"

every 5.minutes do
  runner 'Operations::Shop::Order::CleanupExpired.run'
end
