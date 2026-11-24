require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  # Recent Chrome refuses the call Capybara makes to clear cookies between tests, so clear them here instead. By then
  # the page is about:blank, so ask Chrome to clear every site's cookies, not only the page's.
  def after_teardown
    super
  rescue Selenium::WebDriver::Error::InvalidArgumentError
    page.driver.browser.execute_cdp("Network.clearBrowserCookies")
  end
end
