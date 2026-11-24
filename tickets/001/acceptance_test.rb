require "test_helper"

# Ticket 001: notes vanish sometimes. Each test is one acceptance criterion of the refined ticket.
class Ticket001Test < ActionDispatch::IntegrationTest
  LONG = "Mud past the second bridge. " * 20

  setup { sign_in_as users(:sam) }

  def post_note(body) = post trail_notes_path(trails(:eagle_ridge)), params: { note: { body: } }

  # An error page can contain any text, so check that the form came back before reading what it says.
  def assert_form_shown_again
    assert_includes [ 200, 422 ], response.status, "the trail page should come back with the form, not an error page"
  end

  test "a note over 500 characters isn't saved, and the hiker is told why" do
    assert_no_difference -> { Note.count } do
      post_note LONG
    end
    assert_form_shown_again
    assert_match(/too long|500/i, response.body)
  end

  test "the hiker's words stay in the form, so nothing they wrote is lost" do
    post_note LONG
    assert_select "textarea[name='note[body]']", text: LONG
  end

  test "the page answers 422 Unprocessable Content, so Turbo shows the form again" do
    post_note LONG
    assert_response :unprocessable_content
  end

  test "Note posted. shows only when a note was saved" do
    post_note LONG
    follow_redirect! if response.redirect?
    assert_form_shown_again
    assert_no_match "Note posted.", response.body
  end

  test "a note of 500 characters still posts as before" do
    assert_difference -> { Note.count } do
      post_note "a" * 500
    end
    assert_redirected_to trail_path(trails(:eagle_ridge))
  end
end
