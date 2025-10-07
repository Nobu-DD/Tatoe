import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["theme", "button", "body", "reason"]
  static values = {
    topic: Object
  }

  output() {
    const topic = this.topicValue;
    const theme = this.themeTarget.value;
    this.buttonTarget.innerHTML = `AI出力中...<span class="loading loading-spinner text-info ml-2"></span>`;
    fetch("topics/${topic.id}/answers/generate_ai", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.head.querySelector("meta[name=csrf-token]")?.content
      },
      body: JSON.stringify({
        theme: theme,
        topic: topic
      })
    })
    .then(response => response.json())
    .then(data => {
      this.bodyTarget.value = data["body"];
      this.reasonTarget.value = data["reason"];
      this.buttonTarget.innerHTML = "AI出力"
    })
    .catch((error) => {
      alert("AI生成に失敗しました。時間を置いてもう一度お試しください。");
      console.error(error);
      this.buttonTarget.innerHTML = "AI出力";
    });
  }
}