# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

# Clear the cache before the asset:precompile task
Rake::Task['assets:precompile'].enhance ['tmp:cache:clear']
