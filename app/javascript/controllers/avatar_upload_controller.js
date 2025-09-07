import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="avatar-upload"
export default class extends Controller {
  submitForm(event) {
    this.element.requestSubmit();
  }
}
