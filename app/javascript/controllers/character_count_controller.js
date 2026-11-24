import { Controller } from "@hotwired/stimulus"

// Counts the way Rails' length validation does: one for each code point, so 🥾 is one character, not two.
export default class extends Controller {
  static targets = [ "input", "count", "announcement" ]
  static values = { limit: Number }

  connect() {
    this.show()
  }

  disconnect() {
    clearTimeout(this.pause)
  }

  update() {
    this.show()
    // A screen reader hears the count once the hiker pauses, not after every key.
    clearTimeout(this.pause)
    this.pause = setTimeout(() => { this.announcementTarget.textContent = this.countTarget.textContent }, 1000)
  }

  show() {
    const left = this.limitValue - Array.from(this.inputTarget.value).length
    this.countTarget.textContent = left < 0 ? `${this.#characters(-left)} over the limit` : `${this.#characters(left)} left`
  }

  #characters(count) {
    return `${count} ${count === 1 ? "character" : "characters"}`
  }
}
