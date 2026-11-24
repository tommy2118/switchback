require "test_helper"

class NotifyFollowersJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper
  test "each follower but the author gets an email about a new note, each sent on its own so one bad address can't stop the rest" do
    assert_enqueued_emails 1 do
      NotifyFollowersJob.perform_now(notes(:bridge))
    end
    perform_enqueued_jobs
    assert_equal [ "sam@switchback.test" ], ActionMailer::Base.deliveries.last.to
  end
end
