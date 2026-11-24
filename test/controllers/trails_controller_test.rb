require "test_helper"

class TrailsControllerTest < ActionDispatch::IntegrationTest
  test "the note form says the limit in the page, before any JavaScript runs" do
    sign_in_as users(:sam)

    get trail_path(trails(:eagle_ridge))

    assert_select "#note_body_count", text: "Up to 500 characters."
  end
end
