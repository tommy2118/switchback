# Tickets

Real work on Switchback, one ticket at a time, the way it arrives on the job: written by someone who isn't an
engineer, often vague, sometimes wrong about the cause.

## How to work a ticket

1. **Refine it first.** Read the ticket, then work out what you'd need to know before starting: who hits it, where,
   what they expected, what happened instead. Reproduce it. Write the acceptance criteria and what's out of scope.
   The ticket's page on Understanding Rails lets you ask the reporter questions.
2. **Fork this repository** on GitHub, and clone your fork.
3. **Make a branch named for the ticket,** starting with its number: `001-notes-vanish`.
4. **Work it.** Write a test that fails because of the problem, then fix the code until it passes.
5. **Open a pull request in your fork,** from your branch into your fork's `master`.

CI reviews your pull request: it runs the ticket's acceptance tests and comments on what passes and what doesn't.
When everything passes, it tells you what a human reviewer would still ask.

## Tickets

- [001: Notes vanish sometimes](001-notes-vanish.md)
