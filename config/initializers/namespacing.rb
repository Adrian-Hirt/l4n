# Define a helper method
def setup_namespacing(folder, module_name)
  # Remove the folder from the autoload paths
  app_path = "#{Rails.root}/#{folder}"
  ActiveSupport::Dependencies.autoload_paths.delete(app_path)

  # Define the module if not exists
  if Object.const_defined?("::#{module_name}")
    defined_module = Object.const_get("::#{module_name}")
  else
    defined_module = Object.const_set(module_name, Module.new)
  end

  # Add the folder to the autoloader, but namespaced
  loader = Rails.autoloaders.main
  loader.push_dir(app_path, namespace: defined_module)

  # Add the folder to the watched directories (for re-loading in development)
  Rails.application.config.watchable_dirs.merge!({
                                                   app_path => [:rb]
                                                 })
end

setup_namespacing('app/grids', 'Grids')
setup_namespacing('app/operations', 'Operations')
setup_namespacing('app/queries', 'Queries')
setup_namespacing('app/services', 'Services')
