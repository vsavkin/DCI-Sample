rails_root = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift(rails_root) unless $LOAD_PATH.include?(rails_root)

require 'active_support/dependencies'
autoload_paths = ActiveSupport::Dependencies.autoload_paths
%w(app/models app/contexts app/workers app/presenters lib).each do |path|
  autoload_paths.push(path) unless autoload_paths.include?(path)
end
