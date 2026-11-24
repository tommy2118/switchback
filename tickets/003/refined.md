# 003: The note form doesn't show the 500-character limit until it's too late

**Story:** As a hiker writing a long trail report on my phone, I want to see how much room I have left as I type, so
I can trim my note before I post it, not after.

**What happens today:** sign in, open any trail, and look at the note form. Nothing says there's a limit. Type or paste 600
characters and post. With ticket 001 fixed, the page says the note is too long, but not by how much. Either way, the
hiker finds out only after writing the whole note.

**Why it happens:** the 500-character limit lives only in `Note`'s validation, which runs on the server after the hiker posts.
The form never mentions it.

## Acceptance criteria
1. Before typing, the form says notes can be up to 500 characters, even without JavaScript.
2. As the hiker types, the form shows how many characters are left, counted the way the server counts.
3. The hiker can type past the limit, nothing is cut off, and the form shows how far over it is.
4. A screen reader politely hears how far over the limit the note is.
5. The server still rejects a note over 500 characters, and a note of 500 still posts.

Criterion 2 is about agreeing with the server, not one way to count. Rails' length validation counts code points, so
🥾 is one character and 👨‍👩‍👧 is five. A browser's `value.length` counts UTF-16 units, so 🥾 is two. With Turbo, each
line break reaches the server as one character. Criteria 2 to 4 run in a real browser, headless Chrome. Criteria 1
and 5 run with no JavaScript at all, because the server is what decides.

"Politely" means `aria-live="polite"` or `role="status"`: the screen reader waits until the hiker stops before
speaking. The count can show as left or as used ("419 characters left" or "81 / 500"). Both pass.

## Out of scope
- Raising the limit. Morgan would rather keep 500 if hikers can see it coming.
- Counting what looks like one character, such as 👨‍👩‍👧, as one. The server would have to count that way too.
- Line breaks in a note sent without JavaScript. The browser sends each one as two characters (`\r\n`), so the server
  counts more than Turbo sends. A small next ticket if hikers hit it.
- Ticket 001's error message. If your master doesn't have it yet, do ticket 001 first.
- Editing a note after it's posted.

## What the reporter answered
- **Would raising it to 5,000 fix it?** For a while. People who write long would hit 5,000 instead, and followers
  already say the emails are long. I'd keep 500 if hikers could see it coming.
- **When does a hiker find out about the limit today?** Only after they press Post. Nothing on the form says there's
  a limit.
- **What counts as a character? Do hikers use emoji or line breaks?** All the time. I don't mind how it counts, as
  long as the number they see is the number that gets checked.
- **Should the form stop them typing at 500?** No. Dana pastes reports from her notes app. She should see she's over
  and trim it herself.
- **Does it need to work on a bad connection?** Yes. Some trailheads get one bar, and people post from a half-loaded
  page.
- **Do any hikers use a screen reader?** Yes. Jo posts from her phone with one. She turns off sites that read a number
  after every letter.
- **Why 500? What are hikers writing on? How many have hit this? Can they edit a note? Do long notes cost us
  anything?** Notes are for trail conditions and go out by email. Mostly phones. Six wrote in this month. No editing
  yet. Nothing anyone's mentioned. (The phone matters for the layout; the rest doesn't narrow it.)
