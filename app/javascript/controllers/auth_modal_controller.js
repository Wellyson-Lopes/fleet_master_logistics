import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "loginSection", "registerSection"]

  open(event) {
    const type = event.currentTarget.dataset.authType
    
    // Mostra o overlay e a caixa com transição
    this.overlayTarget.classList.add("open")
    
    // Bloqueia scroll do body
    document.body.style.overflow = "hidden"
    
    this.switchView(type)
  }

  close() {
    this.overlayTarget.classList.remove("open")
    
    // Libera scroll do body
    document.body.style.overflow = ""
  }

  showLogin() {
    this.switchView("login")
  }

  showRegister() {
    this.switchView("register")
  }

  switchView(type) {
    if (type === "login") {
      this.loginSectionTarget.classList.remove("hidden")
      this.registerSectionTarget.classList.add("hidden")
    } else {
      this.loginSectionTarget.classList.add("hidden")
      this.registerSectionTarget.classList.remove("hidden")
    }
  }

  closeOnOutsideClick(event) {
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }

  showToast(message) {
    const existingToast = document.getElementById("auth-toast")
    if (existingToast) existingToast.remove()

    const toast = document.createElement("div")
    toast.id = "auth-toast"
    toast.className = "fixed bottom-5 right-5 z-[100] flex items-center w-full max-w-xs p-4 space-x-4 text-gray-500 bg-white rounded-2xl shadow-xl dark:text-gray-400 dark:bg-gray-800 border border-gray-100 dark:border-gray-700 transition-all duration-300 transform translate-y-10 opacity-0"
    
    toast.innerHTML = `
      <div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-green-500 bg-green-100 rounded-lg dark:bg-green-800 dark:text-green-200">
        <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
          <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 8.207-4 4a1 1 0 0 1-1.414 0l-2-2a1 1 0 0 1 1.414-1.414L9 10.586l3.293-3.293a1 1 0 0 1 1.414 1.414Z"/>
        </svg>
        <span class="sr-only">Ícone de check</span>
      </div>
      <div class="text-sm font-semibold text-gray-900 dark:text-white">${message}</div>
    `
    
    document.body.appendChild(toast)

    setTimeout(() => {
      toast.classList.remove("translate-y-10", "opacity-0")
    }, 10)

    setTimeout(() => {
      toast.classList.add("translate-y-10", "opacity-0")
      setTimeout(() => {
        toast.remove()
      }, 300)
    }, 2700)
  }
}
