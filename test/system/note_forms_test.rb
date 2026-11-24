require "application_system_test_case"

class NoteFormsTest < ApplicationSystemTestCase
  setup do
    visit new_session_path
    fill_in "email_address", with: users(:sam).email_address
    fill_in "password", with: "password"
    within("form") { click_on "Sign in" }
    assert_no_current_path new_session_path
    visit trail_path(trails(:eagle_ridge))
  end

  test "the form shows how many characters are left as the hiker types" do
    note_box.send_keys("Bridge out at mile 2")

    assert_text "480 characters left"
  end

  test "the hiker can type past the limit, keeps every word, and hears how far over" do
    note_box.send_keys("a" * 537)

    assert_equal 537, note_box.value.length
    assert_text "37 characters over the limit"
    assert_selector "[aria-live='polite']", text: "37 characters over the limit", visible: :all
  end

  private
    def note_box = find("textarea[name='note[body]']")
end
