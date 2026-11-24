# Switchback's trails, hikers and notes are invented for Understanding Rails.
password = "switchback-hiker"
sam = User.find_or_create_by!(email_address: "sam@switchback.test") { it.name = "Sam"; it.password = password }
priya = User.find_or_create_by!(email_address: "priya@switchback.test") { it.name = "Priya S."; it.password = password }
marcus = User.find_or_create_by!(email_address: "marcus@switchback.test") { it.name = "Marcus T."; it.password = password }

eagle = Trail.find_or_create_by!(id: 42) { it.name = "Eagle Ridge Loop"; it.miles = 6.2; it.gain_feet = 1840; it.difficulty = "Moderate" }
Trail.find_or_create_by!(name: "Cedar Falls") { it.miles = 3.1; it.gain_feet = 420; it.difficulty = "Easy" }
Trail.find_or_create_by!(name: "Granite Switchbacks") { it.miles = 9.8; it.gain_feet = 3210; it.difficulty = "Hard" }

if eagle.notes.none?
  eagle.notes.create!(author: marcus, body: "Bridge two is slick after rain.", created_at: 1.week.ago)
  eagle.notes.create!(author: priya, body: "Wildflowers at the saddle. Worth the climb.", created_at: 2.days.ago)
end
eagle.follows.find_or_create_by!(user: sam)
