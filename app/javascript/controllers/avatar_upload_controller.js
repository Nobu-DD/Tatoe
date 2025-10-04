import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="avatar-upload"
export default class extends Controller {
  static targets = ["form", "revision"]

  submitForm(event) {
    this.revisionTarget.innerHTML = `画像変更中...<span class="loading loading-spinner text-neutral text-sm text-gray-500 mb-1"></span>`
    this.formTarget.requestSubmit();
  }
}
