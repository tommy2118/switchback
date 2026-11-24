# 002: A trail's page loads each note's author on its own

**Story:** As a hiker checking a busy trail before I go, I want its page to open as fast as a quiet trail's, so I can
read the latest notes without giving up.

**Reproduce:** run `bin/setup`, or `bin/rails db:seed`, so Eagle Ridge Loop has about 400 notes. Open it and read the
log. There's a `User Load` for each note, each pointing at `app/views/notes/_note.html.erb`, and the `Completed` line
counts about 400 queries. Cedar Falls, with two notes, makes four.

**Cause:** the page draws `@trail.notes`, and each note's partial calls `note.author.name`. That loads the author with
a query of its own: one query for the notes, then one more for each note. This is an N+1 query.

## Acceptance criteria
1. A trail's page makes the same number of database queries with 30 notes as with 3.
2. Every note still shows its author's name and its words.
3. Notes are still listed newest first.
4. Posting a note still works, and followers still get their email about it.

Criterion 1 counts queries, not seconds. Time depends on the machine and on what else it's doing; the number of
queries doesn't. A fix can load the authors in one more query or in the same query as the notes. Either way the count
stays the same as the trail grows.

## Out of scope
- Showing fewer notes at a time, with pages or a "Show more" button. How many to show is the product manager's call.
  A good next ticket.
- Caching the page.
- A bigger server. The page is slow when the site is quiet, so a bigger server wouldn't fix it.

## What the reporter answered
- **Are other trails slow too?** No. Cedar Falls and Granite Switchbacks open right away.
- **How many notes does Eagle Ridge have?** Hundreds now. Cedar Falls has two.
- **When did it start?** About a month ago, when the newsletter featured Eagle Ridge. It gets a little worse every week.
- **Is it slow only when the site is busy?** No. It was just as slow at six on a Sunday morning.
- **Is it slow signed out too? Do notes have photos? Did anything change on the server, or when live notes came in?**
  Same signed out. Text only. Nothing changed on the server. Live notes came in the spring, and the page was fast all
  summer. (None of these narrows it.)
