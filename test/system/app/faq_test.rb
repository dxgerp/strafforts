require_relative './app_test_base'

class FaqTest < AppTestBase
  test 'open FAQ page from url should be successful' do
    # act.
    visit_page DEMO_URL + '?view=faq'

    # assert.
    assert_faq_panel_load_successfully
  end

  test 'open FAQ page from header button should be successful' do
    # arrange.
    visit_page DEMO_URL

    # act.
    nav_tab_faq = find(:css, App::Selectors::MainHeader.btn_faq)
    nav_tab_faq.click

    # assert.
    assert_faq_panel_load_successfully
  end

  def assert_faq_panel_load_successfully
    faq_panel = find(:css, '.pane-faq')
    within(faq_panel) do
      assert_has_selector('.nav-tabs li')
      headers = all(:css, '.nav-tabs li')
      assert_equal(FAQ_CATEGORIES.count, headers.count)
      headers.each do |header|
        assert_includes_text(FAQ_CATEGORIES, header.text)
      end
    end
  end
end
