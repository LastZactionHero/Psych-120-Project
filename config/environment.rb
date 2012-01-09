# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Psychtest::Application.initialize!

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://www.purdue.edu/apps/account/cas"
)