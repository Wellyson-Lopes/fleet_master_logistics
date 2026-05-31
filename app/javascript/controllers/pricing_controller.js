import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "toggleSwitch",
    "monthLabel",
    "annualLabel",
    "priceStarter",
    "pricePro",
    "priceEnt",
    "annualStarter",
    "annualPro",
    "annualEnt"
  ]

  initialize() {
    this.isAnnual = false
  }

  toggle(event) {
    if (event && event.target && event.target.type === "checkbox") {
      this.isAnnual = event.target.checked
    } else {
      this.isAnnual = !this.isAnnual
      if (this.hasToggleSwitchTarget && this.toggleSwitchTarget.type === "checkbox") {
        this.toggleSwitchTarget.checked = this.isAnnual
      }
    }

    if (this.isAnnual) {
      if (this.hasMonthLabelTarget) {
        this.monthLabelTarget.classList.remove("text-gray-900", "dark:text-white", "font-bold")
        this.monthLabelTarget.classList.add("text-gray-500", "dark:text-gray-400", "font-normal")
      }
      if (this.hasAnnualLabelTarget) {
        this.annualLabelTarget.classList.remove("text-gray-500", "dark:text-gray-400", "font-normal")
        this.annualLabelTarget.classList.add("text-gray-900", "dark:text-white", "font-bold")
      }

      if (this.hasPriceStarterTarget) this.priceStarterTarget.textContent = "157"
      if (this.hasPriceProTarget) this.priceProTarget.textContent = "317"
      if (this.hasPriceEntTarget) this.priceEntTarget.textContent = "637"

      if (this.hasAnnualStarterTarget) this.annualStarterTarget.textContent = "Cobrança anual · economia de R$ 480/ano"
      if (this.hasAnnualProTarget) this.annualProTarget.textContent = "Cobrança anual · economia de R$ 960/ano"
      if (this.hasAnnualEntTarget) this.annualEntTarget.textContent = "Cobrança anual · economia de R$ 1.920/ano"
    } else {
      if (this.hasMonthLabelTarget) {
        this.monthLabelTarget.classList.remove("text-gray-500", "dark:text-gray-400", "font-normal")
        this.monthLabelTarget.classList.add("text-gray-900", "dark:text-white", "font-bold")
      }
      if (this.hasAnnualLabelTarget) {
        this.annualLabelTarget.classList.remove("text-gray-900", "dark:text-white", "font-bold")
        this.annualLabelTarget.classList.add("text-gray-500", "dark:text-gray-400", "font-normal")
      }

      if (this.hasPriceStarterTarget) this.priceStarterTarget.textContent = "197"
      if (this.hasPriceProTarget) this.priceProTarget.textContent = "397"
      if (this.hasPriceEntTarget) this.priceEntTarget.textContent = "797"

      if (this.hasAnnualStarterTarget) this.annualStarterTarget.textContent = ""
      if (this.hasAnnualProTarget) this.annualProTarget.textContent = ""
      if (this.hasAnnualEntTarget) this.annualEntTarget.textContent = ""
    }
  }
}
