// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "flowbite";

// Inicialização contínua do Flowbite compatível com Turbo (Hotwire) de forma local
function initFlowbiteComponents() {
  if (typeof initFlowbite === 'function') {
    initFlowbite();
  }
}
document.addEventListener("DOMContentLoaded", initFlowbiteComponents);
document.addEventListener("turbo:load", initFlowbiteComponents);
document.addEventListener("turbo:render", initFlowbiteComponents);

