import { Controller } from "@hotwired/stimulus"

// Gerencia a seleção interativa da máquina, tipo de aluguel (hora ou diária),
// preenchimento automático das taxas e cálculo dinâmico do valor total.
export default class extends Controller {
  static targets = ["machinerySelect", "rentalType", "duration", "rateApplied", "totalAmount"]

  connect() {
    this.calculate()
  }

  updateMachinery() {
    const selectedOption = this.machinerySelectTarget.selectedOptions[0]
    if (!selectedOption || !selectedOption.value) return

    const hourlyRate = parseFloat(selectedOption.dataset.hourlyRate || "0")
    const dailyRate = parseFloat(selectedOption.dataset.dailyRate || "0")

    const type = this.rentalTypeTarget.value
    if (type === "hourly") {
      this.rateAppliedTarget.value = hourlyRate.toFixed(2)
    } else {
      this.rateAppliedTarget.value = dailyRate.toFixed(2)
    }

    this.calculate()
  }

  updateRentalType() {
    this.updateMachinery()
  }

  calculate() {
    const duration = parseFloat(this.durationTarget.value || "0")
    const rate = parseFloat(this.rateAppliedTarget.value || "0")
    const total = duration * rate

    if (this.hasTotalAmountTarget) {
      this.totalAmountTarget.textContent = new Intl.NumberFormat("pt-BR", {
        style: "currency",
        currency: "BRL"
      }).format(total)
    }
  }
}
