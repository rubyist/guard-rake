# $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
# $LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))
require 'guard/rake'

require 'rspec'
require 'rspec/autorun'

# custom spec helpers
support_files = File.expand_path('spec/support/**/*.rb')
Dir[support_files].each { |file| require file }
