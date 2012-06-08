rails_root = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift(rails_root) unless $LOAD_PATH.include?(rails_root)

require 'active_support/dependencies'

%w(app/models).each do |path|
  ActiveSupport::Dependencies.autoload_paths.push(path) unless ActiveSupport::Dependencies.autoload_paths.include?(path)
end
