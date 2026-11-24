require "test_helper"

class TrailsControllerTest < ActionDispatch::IntegrationTest
  test "a trail's page loads its notes' authors together, not one by one" do
    trail = Trail.create!(name: "Busy Trail")
    5.times do |i|
      author = User.create!(name: "Hiker #{i}", email_address: "hiker#{i}@switchback.test", password: "switchback-hiker")
      trail.notes.create!(author:, body: "Note #{i} on the busy trail.")
    end

    assert_queries_count(3) { get trail_path(trail) }
    assert_response :success
    assert_select "article", 5
  end
end
