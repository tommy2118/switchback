require "test_helper"

# Ticket 002: Eagle Ridge's page is slow. Each test is one acceptance criterion of the refined ticket.
class Ticket002Test < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  # Each note gets its own author, so a page that loads authors one by one can't hide behind the query cache.
  def trail_with(count, name: "Busy Trail #{count}")
    trail = Trail.create!(name:)
    count.times do |i|
      label = format("%02d", i + 1)
      author = User.create!(name: "Author #{label}", email_address: "author#{label}-#{trail.id}@switchback.test", password: "switchback-hiker")
      trail.notes.create!(author:, body: "Note #{label} on #{name}.", created_at: (count - i).hours.ago)
    end
    trail
  end

  # Counts the queries that reach the database while the page is drawn, after checking it drew every note.
  def queries_to_show(trail)
    count = 0
    counter = ->(*, payload) { count += 1 unless payload[:name] == "SCHEMA" || payload[:cached] }
    ActiveSupport::Notifications.subscribed(counter, "sql.active_record") { get trail_path(trail) }
    assert_response :success
    trail.notes.each { assert_includes response.body, it.author.name, "the page should show every note" }
    count
  end

  test "a trail's page makes the same number of database queries with 30 notes as with 3" do
    few = queries_to_show(trail_with(3))
    many = queries_to_show(trail_with(30))
    assert_equal few, many, "3 notes took #{few} queries and 30 notes took #{many}, so the page still loads something once for each note"
  end

  test "every note still shows its author's name and its words" do
    trail = trail_with(3)
    get trail_path(trail)
    assert_response :success
    trail.notes.each do |note|
      assert_includes response.body, note.author.name, "a note's author is missing from the page"
      assert_includes response.body, note.body, "a note's words are missing from the page"
    end
  end

  test "notes are still listed newest first" do
    trail = trail_with(3)
    get trail_path(trail)
    assert_response :success
    shown = [ "Note 03", "Note 02", "Note 01" ].map { response.body.index(it) }
    assert shown.all? && shown == shown.sort, "the newest note should be at the top, then the older ones"
  end

  test "posting a note still works, and followers still get their email about it" do
    sign_in_as users(:priya)
    perform_enqueued_jobs do
      post trail_notes_path(trails(:eagle_ridge)), params: { note: { body: "Fog on the ridge until ten." } }
    end
    assert_redirected_to trail_path(trails(:eagle_ridge))
    assert_includes ActionMailer::Base.deliveries.flat_map(&:to), users(:sam).email_address, "Sam follows the trail and should get an email"
    get trail_path(trails(:eagle_ridge))
    assert_includes response.body, "Fog on the ridge until ten.", "the new note should be on the trail's page"
  end
end
