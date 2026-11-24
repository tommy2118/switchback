require "test_helper"

class NotifyFollowersJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper
  test "each follower but the author gets an email about a new note" do
    assert_emails 1 do
      NotifyFollowersJob.perform_now(notes(:bridge))
    end
    assert_equal [ "sam@switchback.test" ], ActionMailer::Base.deliveries.last.to
  end
end
