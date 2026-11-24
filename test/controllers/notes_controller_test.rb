require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  test "a signed-in hiker posts a note on a trail" do
    sign_in_as users(:sam)

    assert_difference -> { trails(:eagle_ridge).notes.count } do
      post trail_notes_path(trails(:eagle_ridge)), params: { note: { body: "Mud past the second bridge. Bring gaiters." } }
    end
    assert_redirected_to trail_path(trails(:eagle_ridge))
    assert_equal users(:sam), Note.last.author
  end

  test "posting needs a signed-in hiker" do
    post trail_notes_path(trails(:eagle_ridge)), params: { note: { body: "Hello" } }
    assert_redirected_to new_session_path
  end
end
