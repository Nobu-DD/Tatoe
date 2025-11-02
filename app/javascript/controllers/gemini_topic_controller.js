import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gemini_topic"
export default class extends Controller {
  static targets = ["genre", "compare", "title", "description", "genres", "hint_1", "hint_2", "hint_3", "button"]

  output() {
    // ユーザーが入力された文字列(AIにわたす)
    const genre = this.genreTarget.value;
    const compare = this.compareTarget.value;
    this.buttonTarget.innerHTML = `AI出力中...<span class="loading loading-spinner text-info ml-2"></span>`;
    // 文字列をサーバーにわたす
    fetch("generate_ai", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.head.querySelector("meta[name=csrf-token]")?.content
      },
      body: JSON.stringify({
        genre: genre,
        compare: compare
      })
    })
    .then(response => response.json())
    .then(data => {
      this.titleTarget.value = data["title"];
      this.descriptionTarget.value = data["description"];
      this.genresSetting(data["genres"]);
      this.hint_1Target.value = data["hints"]["hint_1"];
      this.hint_2Target.value = data["hints"]["hint_2"];
      this.hint_3Target.value = data["hints"]["hint_3"];
      this.buttonTarget.innerHTML = "AI出力"
    })
      .catch((error) => {
        alert("AI生成に失敗しました。時間を置いてもう一度お試しください。");
        console.error(error);
      this.buttonTarget.innerHTML = "AI出力";
    });
  }

  genresSetting(genres) {
    genres.forEach((genre) => {

    })
  }
}
