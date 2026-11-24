# Switchback's trails, hikers and notes are invented for Understanding Rails.
password = "switchback-hiker"
sam = User.find_or_create_by!(email_address: "sam@switchback.test") { it.name = "Sam"; it.password = password }
priya = User.find_or_create_by!(email_address: "priya@switchback.test") { it.name = "Priya S."; it.password = password }
marcus = User.find_or_create_by!(email_address: "marcus@switchback.test") { it.name = "Marcus T."; it.password = password }

eagle = Trail.find_or_create_by!(id: 42) { it.name = "Eagle Ridge Loop"; it.miles = 6.2; it.gain_feet = 1840; it.difficulty = "Moderate" }
cedar = Trail.find_or_create_by!(name: "Cedar Falls") { it.miles = 3.1; it.gain_feet = 420; it.difficulty = "Easy" }
Trail.find_or_create_by!(name: "Granite Switchbacks") { it.miles = 9.8; it.gain_feet = 3210; it.difficulty = "Hard" }

if eagle.notes.none?
  eagle.notes.create!(author: marcus, body: "Bridge two is slick after rain.", created_at: 1.week.ago)
  eagle.notes.create!(author: priya, body: "Wildflowers at the saddle. Worth the climb.", created_at: 2.days.ago)
end
if cedar.notes.none?
  cedar.notes.create!(author: priya, body: "Falls are loud after the rain. Easy walk.", created_at: 3.days.ago)
  cedar.notes.create!(author: marcus, body: "Good one for kids.", created_at: 1.day.ago)
end
eagle.follows.find_or_create_by!(user: sam)

# Eagle Ridge got popular: hundreds of notes from many hikers, so its page is slow the way ticket 002 describes.
# insert_all skips callbacks, so seeding sends no emails and no live updates.
if eagle.notes.count < 100
  now = Time.current
  first = %w[ Ana Ben Cleo Dev Eli Fern Gus Hana Ivan Jo Kai Lena Milo Nia Omar Pia Quinn Rafa Sol Tess Uma Vik Wren Yuki Zoe ]
  hikers = first.product(%w[ B. K. M. ]).map { |name, initial| "#{name} #{initial}" }
  digest = BCrypt::Password.create(password)
  User.insert_all(hikers.map { |name| { name:, email_address: "#{name.downcase.delete(". ")}@switchback.test",
                                        password_digest: digest, created_at: now, updated_at: now } })
  authors = User.where(name: hikers).ids
  bodies = [ "Parked at the north lot by seven. Full by nine.", "Bridge two is still slick. Go slow.",
             "Saw a hawk riding the ridge wind for ten minutes.", "Wildflowers are thinning out at the saddle.",
             "Trail is dry all the way around.", "Bring more water than you think. No shade after mile two.",
             "Crowded on the weekend. Go on a weekday if you can.", "The loop is easier clockwise." ]
  Note.insert_all(Array.new(400) do |i|
    at = now - (i * 97).minutes
    { trail_id: eagle.id, author_id: authors[i % authors.size], body: bodies[i % bodies.size], created_at: at, updated_at: at }
  end)
end
