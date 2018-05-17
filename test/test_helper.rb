require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  delegate :parsed_body, to: :response

  def setup
    self.default_url_options = { locale: I18n.default_locale }
  end

  def assert_redirected_to_login
    assert_redirected_to new_user_session_path(locale: nil)
  end

  def json_response
    JSON.parse(response.body, object_class: OpenStruct)
  end
end
