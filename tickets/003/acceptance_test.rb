require "test_helper"

# Ticket 003: long notes get rejected. Each test is one acceptance criterion of the refined ticket.
# The counter runs in the hiker's browser, so these tests drive headless Chrome; the checks without JavaScript use
# Capybara's rack_test driver, which runs no JavaScript at all.
class Ticket003Test < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome

  # Rails counts 81 characters here, one for each code point. A browser's value.length counts 87, because each of
  # these emoji takes two UTF-16 units. Counting what looks like one character gives 77: the family is five code points.
  REPORT = "Bridge out at mile 2 🌉\nWade the creek instead 🥾🥾\nFamily friendly after that 👨‍👩‍👧"

  setup { @trail = Trail.create!(name: "Quiet Hollow", miles: 3, gain_feet: 140, difficulty: "Easy") }

  # Recent Chrome refuses the call Capybara makes to clear cookies between tests, so clear them here instead.
  def after_teardown
    super
  rescue Selenium::WebDriver::Error::InvalidArgumentError
    page.driver.browser.manage.delete_all_cookies
  end

  # Turbo waits for each page's live updates to connect, and without JavaScript they never do.
  def connect_turbo_cable_stream_sources(...) = (super unless Capybara.current_driver == :rack_test)

  def sign_in
    visit new_session_path
    fill_in "email_address", with: users(:sam).email_address
    fill_in "password", with: "password"
    within("form") { click_on "Sign in" }
    assert_no_current_path new_session_path
  end

  def open_the_trail
    visit trail_path(@trail)
    assert_selector "textarea[name='note[body]']"
    find("textarea[name='note[body]']")
  end

  # The numbers on the page, as the hiker sees them, after the counter has had a moment to catch up.
  def shows_number?(*numbers) = page.has_text?(/(?<!\d)(?:#{numbers.join("|")})(?!\d)/, wait: 3)

  test "before typing, the form says notes can be up to 500 characters, even without JavaScript" do
    Capybara.using_driver(:rack_test) do
      sign_in
      open_the_trail
      assert_text(/\b500\b/, wait: 0)
    end
  end

  test "as the hiker types, the form shows how many characters are left, counted the way the server counts" do
    sign_in
    open_the_trail.send_keys(REPORT)
    counted = REPORT.length
    shown = shows_number?(500 - counted, counted)
    page_text = page.text
    click_on "Post note"
    assert_text "Wade the creek"
    assert_equal counted, Note.find_by!(trail: @trail).body.length, "the server should count the note as #{counted} characters"
    assert shown, "with #{counted} characters typed, the form should show #{500 - counted} left (or #{counted} used). " \
                  "Rails counts one character for each code point: 🥾 is one, 👨‍👩‍👧 is five, a line break is one. The page said: #{page_text.squish}"
  end

  test "the hiker can type past the limit, nothing is cut off, and the form shows how far over it is" do
    sign_in
    note = open_the_trail
    note.send_keys("a" * 537)
    assert_equal 537, note.value.length, "all 537 characters the hiker typed should stay in the box"
    assert shows_number?(37, 537), "with 537 characters typed, the form should show 37 over (or 537 used). The page said: #{page.text.squish}"
  end

  test "a screen reader politely hears how far over the limit the note is" do
    sign_in
    open_the_trail.send_keys("a" * 537)
    polite = "[aria-live='polite'], [role='status']:not([aria-live])"
    assert_selector polite, text: /(?<!\d)(?:37|537)(?!\d)/, visible: :all, wait: 5
  end

  test "the server still rejects a note over 500 characters, and a note of 500 still posts" do
    Capybara.using_driver(:rack_test) do
      sign_in
      assert_no_difference -> { Note.count } do
        open_the_trail.set("a" * 501)
        click_on "Post note"
      end
      assert_difference -> { Note.count } do
        open_the_trail.set("a" * 500)
        click_on "Post note"
      end
    end
  end
end
