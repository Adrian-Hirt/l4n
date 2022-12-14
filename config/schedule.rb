# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
#
# run `whenever --update-crontab` to install the crontabs

set :output, "#{Whenever.path}/log/cron.log"

# This is needed in order to have all the needed env vars set
ENV.each { |k, v| env(k, v) }

every 2.minutes do
  runner 'Operations::Admin::Order::CleanupExpired.run'
end

every 15.minutes do
  runner 'Operations::Session::ExpireOld.run'
end

every 4.hours do
  runner 'Rails.cache.cleanup'
end
