import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="topics-search"
export default class extends Controller {
  static targets = ["details_button", "icon_arrow_button", "advanced_search", "form_submit"]

  show_details() {
    console.log("詳細画面展開ィィィィィィ！！！")
    this.icon_arrow_buttonTarget.className = "absolute -top-[3px] inline-block box-border w-[13px] h-[13px] border-solid border-t-3 border-r-3 border-cyan-400 -rotate-45";
    this.advanced_searchTarget.classList.remove("hidden");
    this.details_buttonTarget.dataset.action = "click->topics-search#close_details";
  }

  close_details() {
    console.log("詳細画面閉じィィィィィィ！！！")
    this.icon_arrow_buttonTarget.className = "absolute -top-[10px] inline-block box-border w-[13px] h-[13px] border-solid border-t-3 border-r-3 border-cyan-400 rotate-135";
    this.advanced_searchTarget.classList.add("hidden");
    this.details_buttonTarget.dataset.action = "click->topics-search#show_details";
  }

  sort_change() {
    console.log("領域展開...")
    this.form_submitTarget.click()
  }
}