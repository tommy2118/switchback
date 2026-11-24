# 001: A note over 500 characters is lost without an error

**Story:** As a hiker who writes long trail notes, I want to be told when my note is too long, and keep what I wrote,
so I don't lose a long report.

**Reproduce:** sign in, open any trail, and post a note longer than 500 characters. The page says "Note posted.", and
the note isn't in the list. Nothing deletes notes: this one was never saved.

**Cause:** `NotesController#create` ignores whether `save` worked and always redirects with "Note posted."

## Acceptance criteria
1. A note over 500 characters isn't saved, and the hiker is told why.
2. The hiker's words stay in the form, so nothing they wrote is lost.
3. The page answers 422 Unprocessable Content, so Turbo shows the form again.
4. "Note posted." shows only when a note was saved.
5. A note of 500 characters still posts as before.

## Out of scope
- Changing the 500-character limit.
- Showing the limit, or a character counter, before the hiker hits it. A good next ticket.
- Getting back notes already lost. They were never saved, so there's nothing to restore.

## What the reporter answered
- **Did you see an error?** No. It said "Note posted."
- **Were the lost notes long?** Yes. I write a lot, especially after a washout.
- **Do short notes stay?** Yes, those are all still there.
- **Which trail, and which browser?** Granite Switchbacks, but I've had it on Eagle Ridge too. Chrome on my laptop. (It doesn't depend on either.)
- **Did anyone else see the note?** No one ever saw it.
