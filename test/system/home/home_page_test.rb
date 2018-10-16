require 'application_system_test_case'

class HomePageTest < ApplicationSystemTestCase
  ABOUT = 'ABOUT'.freeze
  DEMO = 'DEMO'.freeze
  CONNECT = 'CONNECT'.freeze

  test 'home page should load with the correct title' do
    # act.
    visit_page HOME_URL

    # assert.
    assert_title("#{APP_NAME} - #{APP_DESCRIPTION}")
  end
end
