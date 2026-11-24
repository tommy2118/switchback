require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "a note needs a body" do
    assert_not Note.new(trail: trails(:eagle_ridge), author: users(:sam), body: "").valid?
  end
end
