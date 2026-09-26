import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label"]

  connect() {
    this.syncTheme()
  }

  toggle(event) {
    if (event) event.preventDefault()

    const isCurrentlyDark = document.documentElement.classList.contains("dark")
    const nextTheme = isCurrentlyDark ? "light" : "dark"

    if (nextTheme === "dark") {
      document.documentElement.classList.add("dark")
      document.body.classList.add("dark")
    } else {
      document.documentElement.classList.remove("dark")
      document.body.classList.remove("dark")
    }

    try {
      localStorage.setItem("fleetmaster-theme", nextTheme)
    } catch (e) {
      // ignore
    }

    this.updateLabels(nextTheme === "dark")
  }

  syncTheme() {
    let isDark = false
    try {
      const stored = localStorage.getItem("fleetmaster-theme")
      if (stored) {
        isDark = stored === "dark"
      } else {
        isDark = window.matchMedia("(prefers-color-scheme: dark)").matches
      }
    } catch (e) {
      isDark = false
    }

    if (isDark) {
      document.documentElement.classList.add("dark")
      document.body.classList.add("dark")
    } else {
      document.documentElement.classList.remove("dark")
      document.body.classList.remove("dark")
    }

    this.updateLabels(isDark)
  }

  updateLabels(isDark) {
    const text = isDark ? "Modo Claro" : "Modo Escuro"
    document.querySelectorAll('[data-theme-target="label"]').forEach((el) => {
      el.textContent = text
    })
  }
}
