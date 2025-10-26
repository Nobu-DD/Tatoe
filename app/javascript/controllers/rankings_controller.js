import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rankings"
export default class extends Controller {
  static targets = ["general_button", "week_button", "month_button", "like_button", "answer_button", "current_period", "current_sort", "reactions_button", "empathy_button", "consent_button", "smile_button" ]

  period_change(event) {
    console.log("ランキングを期間で切り替え");

    const contentTargets = [this.general_buttonTarget, this.week_buttonTarget, this.month_buttonTarget];
    const clickedElement = event.currentTarget;
    const beforeContent = clickedElement.dataset.beforeContent;
    const afterContent = clickedElement.dataset.afterContent;

    this[`${beforeContent}_buttonTarget`].className = "btn btn-outline btn-info rounded-xl";
    this[`${afterContent}_buttonTarget`].className = "btn btn-info rounded-xl pointer-events-none";
    contentTargets.forEach(target => {
      if (!(target.dataset.rankingsTarget == `${afterContent}_button`)) {
        target.dataset.beforeContent = `${afterContent}`;
      }
    })
    delete clickedElement.dataset.beforeContent;

    this.current_periodTarget.value = clickedElement.dataset.currentPeriod
  }

  topics_sort_change(event) {
    const clickedElement = event.currentTarget;
    const beforeContent = clickedElement.dataset.beforeContent;
    const afterContent = clickedElement.dataset.afterContent;

    this[`${beforeContent}_buttonTarget`].className = "btn btn-outline btn-info rounded-xl";
    this[`${afterContent}_buttonTarget`].className = "btn btn-info rounded-xl pointer-events-none";
    this[`${beforeContent}_buttonTarget`].dataset.beforeContent = `${afterContent}`;
    delete clickedElement.dataset.beforeContent

    this.current_sortTarget.value = `${afterContent}s_count desc`
  }

  answers_sort_change(event) {
    const contentTargets = [this.reactions_buttonTarget, this.empathy_buttonTarget, this.consent_buttonTarget, this.smile_buttonTarget];
    const clickedElement = event.currentTarget;
    const beforeContent = clickedElement.dataset.beforeContent;
    const afterContent = clickedElement.dataset.afterContent;

    this[`${beforeContent}_buttonTarget`].className = "btn btn-outline btn-info rounded-xl";
    this[`${afterContent}_buttonTarget`].className = "btn btn-info rounded-xl pointer-events-none";
    contentTargets.forEach(target => {
      if (!(target.dataset.rankingsTarget == `${afterContent}_button`)) {
        target.dataset.beforeContent = `${afterContent}`;
      }
    })
    delete clickedElement.dataset.beforeContent;

    this.current_sortTarget.value = `${afterContent}_count desc`
  }
}