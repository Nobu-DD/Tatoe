import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rankings"
export default class extends Controller {
  static targets = ["general_button", "week_button", "month_button", "reference_like", "reference_topic"]

  period_change(event) {
    console.log("ランキングを期間で切り替え");

    // data-beforeを書き換えるための配列を作成
    const periodTargets = [this.general_buttonTarget, this.week_buttonTarget, this.month_buttonTarget];
    const clickedElement = event.currentTarget;
    const beforePeriod = clickedElement.dataset.beforePeriod;
    const afterPeriod = clickedElement.dataset.afterPeriod;

    this[`${beforePeriod}_buttonTarget`].className = "btn btn-outline btn-info rounded-xl";
    this[`${afterPeriod}_buttonTarget`].className = "btn btn-info rounded-xl pointer-events-none";
    periodTargets.forEach(target => {
      if (!(target.dataset.rankingsTarget == `${afterPeriod}_button`)) {
        target.dataset.beforePeriod = `${afterPeriod}`;
      }
    })
    delete clickedElement.dataset.beforePeriod;
  }
}