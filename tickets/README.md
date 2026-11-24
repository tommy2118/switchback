# Tickets

Real work on Switchback, one ticket at a time, the way it arrives on the job: written by someone who isn't an
engineer, often vague, sometimes wrong about the cause.

## How to work a ticket

1. **Fork this repository** on GitHub, then clone your fork and run `bin/setup` (see the README).
2. **Turn on Actions in your fork.** GitHub leaves a new fork's workflows off. Open your fork's **Actions** tab and
   click **I understand my workflows, go ahead and enable them**. Without this, nothing reviews your pull request.
3. **Refine the ticket.** Read it, then work out what you'd need to know before starting: who hits it, where, what
   they expected, what happened instead. Reproduce it in your running app. Write the acceptance criteria and what's
   out of scope. The ticket's page on Understanding Rails lets you ask the reporter questions.
4. **Make a branch named for the ticket,** starting with its number: `git switch -c 001-notes-vanish`.
5. **Work it.** Write a test that fails because of the problem, then fix the code until it passes.
6. **Open a pull request inside your fork,** from your branch into your fork's `master`. GitHub suggests the original
   repository as the base: change **base repository** to your fork. With the GitHub CLI, run
   `gh repo set-default <your-name>/switchback` once first.

CI reviews your pull request: it runs the ticket's acceptance tests and comments on what passes, what fails, and what
crashed. When everything passes, it tells you what a human reviewer would still ask. Push again and the comment
updates. The same review is in the run's summary on the Actions tab.

The acceptance tests and a reference fix are on this repository's `review` branch. They're public, so you can look.
You'll learn more if you look after you've tried.

## Tickets

- [001: Notes vanish sometimes](001-notes-vanish.md)
- [002: Eagle Ridge's page is slow](002-eagle-ridge-slow.md)
