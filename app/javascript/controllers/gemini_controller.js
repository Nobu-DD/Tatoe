import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gemini"
export default class extends Controller {
  static targets = ["genre", "title", "compare"]

  output() {
    // ユーザーが入力された文字列(AIにわたす)
    const genre = this.genreTarget.value
    const compare = this.compareTarget.value
    // 文字列をサーバーにわたす
    fetch("generate_ai", {
      method: "POST",
      headers: {
        "content-Type": "application/json",
        "X-CSRF-Token": document.head.querySelector("meta[name=csrf-token]")?.content
      },
      body: JSON.stringify({
        genre: genre,
        compare: compare
      })
    })
      .then(response => response.json())
      .then(data => {
        this.titleTarget.value = data.text
    })
  }
}
