import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form_button", "form"]

  appear() {
    this.form_buttonTarget.classList.replace('bg-[#A0D8EF]', 'bg-[#FF627E]')
    this.form_buttonTarget.classList.remove('hover:bg-[#A0D8EF]')
    this.form_buttonTarget.classList.add('hover:bg-[#E0556C]')
    this.form_buttonTarget.innerHTML = "コメントキャンセル"
    this.form_buttonTarget.setAttribute("data-action", "click->comment#disappear")
    this.formTarget.classList.remove("hidden")
  }
  disappear() {
    this.form_buttonTarget.classList.replace('bg-[#FF627E]', 'bg-[#A0D8EF]')
    this.form_buttonTarget.classList.remove('hover:bg-[#E0556C]')
    this.form_buttonTarget.classList.add('hover:bg-[#7CC7E8]')
    this.form_buttonTarget.innerHTML = "コメント投稿"
    this.form_buttonTarget.setAttribute("data-action", "click->comment#appear")
    this.formTarget.classList.add("hidden")
  }
}