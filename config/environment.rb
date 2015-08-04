# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
CrushIt::Application.initialize!

Rails.logger = Le.new('0b6c07ab-d9d8-4119-8883-75599b11005c', :debug => true, :local => true)
