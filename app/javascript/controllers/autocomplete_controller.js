import { Controller } from "@hotwired/stimulus"

const optionSelector = "[role='option']:not([aria-disabled])"
const activeSelector = "[aria-selected='true']"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["input", "hidden", "results", "labels", "flash"]
  static classes = ["selected"]
  static values = {
    ready: Boolean,
    submitOnEnter: Boolean,
    url: String,
    minLength: Number,
    delay: { type: Number, default: 300 },
    queryParam: { type: String, default: "q" },
  }
  static uniqOptionId = 0
	// DOM読み込み時に毎回発動
  connect() {
    this.close()
    console.log("オートコンプリート")

    if(!this.inputTarget.hasAttribute("autocomplete")) this.inputTarget.setAttribute("autocomplete", "off")
    this.inputTarget.setAttribute("spellcheck", "false")

    this.mouseDown = false

    this.onInputChange = debounce(this.onInputChange, this.delayValue)

    this.inputTarget.addEventListener("keydown", this.onKeydown)
    this.inputTarget.addEventListener("blur", this.onInputBlur)
    this.inputTarget.addEventListener("focus", this.onInputFocus)
    this.inputTarget.addEventListener("input", this.onInputChange)
    this.resultsTarget.addEventListener("mousedown", this.onResultsMouseDown)

    if (this.inputTarget.hasAttribute("autofocus")) {
      this.inputTarget.focus()
    }

    this.readyValue = true
  }
  // DOM切断時に毎回発動
  disconnect() {
    if (this.hasInputTarget) {
      this.inputTarget.removeEventListener("keydown", this.onKeydown)
      this.inputTarget.removeEventListener("blur", this.onInputBlur)
      this.inputTarget.removeEventListener("focus", this.onInputFocus)
      this.inputTarget.removeEventListener("input", this.onInputChange)
    }

    if (this.hasResultsTarget) {
      this.resultsTarget.removeEventListener("mousedown", this.onResultsMouseDown)
      this.resultsTarget.removeEventListener("click", this.onResultsClick)
    }
  }

  // input以外をクリックした時(フォーカスを失う)、オートコンプリート表示を消去する処理
  onInputBlur = () => {
    if (this.mouseDown) return
    this.close()
    this.flashTarget.classList.remove("alert", "alert-info", "alert-error", "mb-3")
    this.flashTarget.innerHTML = ""
  }

  // inputをクリックした時(フォーカスした時)、オートコンプリートを再度表示する処理
  onInputFocus = () => {
    if (!this.resultsTarget.querySelector('[role="option"]')) return
    this.open()
  }

  // 検索候補をparamsに保存する処理
  commit(selected) {
    // selectedの属性にaria-disabled: trueが定義されていればfalseを返す
    if (selected.getAttribute("aria-disabled") === "true") return

    // data-autocomplete-labelに値があれば取得する。なければターゲット内で定義している文字列を取得
    const textValue = selected.getAttribute("data-autocomplete-label") || selected.textContent.trim()

    const genreId = selected.getAttribute("id")
    this.inputTarget.value = ""
    
    this.addTopicGenre(genreId, textValue)

    // inputにフォーカスを設定し、検索候補を消去
    this.inputTarget.focus()
    this.hideAndRemoveOptions()
  }

  // ジャンル取り消しボタンとparams追加
  addTopicGenre = (id, name) => {
    const genreButton = document.createElement("button")
    genreButton.classList.add("bg-[#E0F2FE]","hover:bg-[#ACCDE2]","cursor-pointer","text-[#0369A1]","text-lg","px-2","py-1","rounded-full","mb-2")
    genreButton.setAttribute("type","button")
    genreButton.setAttribute("id", id)
    genreButton.innerHTML = `${name}   ✕`
    this.labelsTarget.appendChild(genreButton)
    genreButton.addEventListener("click", this.onDeleteGenre)

    // 選択されたジャンル文字列をgenre_names[]に格納(hidden)
    const genreElement = document.createElement("input")
    genreElement.setAttribute("type", "hidden")
    genreElement.setAttribute("name", "topic[genre_names][]")
    genreElement.setAttribute("id", id)
    genreElement.value = name
    this.hiddenTarget.appendChild(genreElement)     
  }

  // 押したジャンルの削除処理(hiddenの値消去)
  onDeleteGenre = (event) => {
    const genreId = event.target.id
    event.target.remove()
    this.hiddenTarget.querySelector(`#${genreId}`).remove()
  }

    // 検索候補をクリックした時、一番最初に実行(blurを無効化)
  onResultsMouseDown = () => {
    this.mouseDown = true
    this.resultsTarget.addEventListener("mouseup", () => {
      this.mouseDown = false
    }, { once: true })
  }
  // 検索候補をクリックした時の処理
  onResultsClick = (event) => {
    if (!(event.target instanceof Element)) return
    const selected = event.target.closest(optionSelector)
    if (selected) this.commit(selected)
  }

  // テキストフィールドに値を入力すると発火
  onInputChange = () => {
    if (this.hasHiddenTarget) this.hiddenTarget.value = ""

    const query = this.inputTarget.value.trim()
    if (query && query.length >= this.minLengthValue) {
      this.fetchResults(query)
    } else {
      this.hideAndRemoveOptions()
    }
  }

  // リクエスト＆レスポンスの処理
  fetchResults = async (query) => {
    if (!this.hasUrlValue) return

    const url = this.buildURL(query)
    try {
      this.element.dispatchEvent(new CustomEvent("loadstart"))
      const html = await this.doFetch(url)
      this.replaceResults(html)
      this.element.dispatchEvent(new CustomEvent("load"))
      this.element.dispatchEvent(new CustomEvent("loadend"))
    } catch(error) {
      this.element.dispatchEvent(new CustomEvent("error"))
      this.element.dispatchEvent(new CustomEvent("loadend"))
      throw error
    }
  }

  // リクエスト用のURLを作成
  buildURL(query) {
    const url = new URL(this.urlValue, window.location.href)
    const params = new URLSearchParams(url.search.slice(1))
    params.append(this.queryParamValue, query)
    url.search = params.toString()

    return url.toString()
  }

  // リクエスト送信＆HTML型式のレスポンスの受取
  doFetch = async (url) => {
    const response = await fetch(url, this.optionsForFetch())

    if (!response.ok) {
      throw new Error("サーバーからの応答にエラーが出ました")
    }

    const html = await response.text()
    return html
  }

  // 検索候補を削除する
  hideAndRemoveOptions() {
    this.close()
    this.resultsTarget.innerHTML = null
  }

  // リクエストのヘッダー情報を入力(CSRF対策)
  optionsForFetch() {
    return { headers: { "X-Requested-With": "XMLHttpRequest" } }
  }

  // viewに検索結果を反映させる処理
  replaceResults(html) {
    this.resultsTarget.innerHTML = html

    if (!!this.resultsTarget.querySelector("li")) {
      const genres = this.resultsTarget.querySelectorAll("li")
      const genresName = [...genres].map(li => li.innerHTML.trim())
      this.addGenreCreateButton(genresName)
    }
    if (!!this.options.length) {
      this.open()
    }
  }

  // オートコンプリート表示を展開させる処理
  open() {
    if (this.resultsShown) return

    this.resultsShown = true
    this.element.setAttribute("aria-expanded", "true")
  }

  // オートコンプリート表示を終了させる処理
  close() {
    if (!this.resultsShown) return

    this.resultsShown = false
    this.inputTarget.removeAttribute("aria-activedescendant")
    this.element.setAttribute("aria-expanded", "false")
  }

  // ジャンルを登録するボタンを表示
  addGenreCreateButton(genres) {
    const genreName = this.inputTarget.value
    if (!genreName.length && genres.some((name) => name === genreName )) return
    this.resultsShown = true
    this.element.setAttribute("aria-expanded", "true")
    const genreButton = document.createElement("button")
    genreButton.setAttribute("type", "button")
    genreButton.setAttribute("role", "option")
    genreButton.classList.add("btn", "btn-lg", "btn-outline", "btn-info")
    genreButton.setAttribute("name", "genre")
    genreButton.value = `${genreName}`
    genreButton.innerHTML = `"${genreName}"を登録して選択`
    genreButton.addEventListener("click",this.genreCreate)
    this.resultsTarget.appendChild(genreButton)
  }

  // フラッシュメッセージを定義する処理
  addFlash(response) {
    // お題ジャンルを追加
    switch (response.status) {
    case "create":
      this.flashTarget.classList.add("alert", "alert-info", "mb-3")
      this.flashTarget.innerHTML = response.message
      break
    case "unprocessable_entity":
      this.flashTarget.classList.add("alert", "alert-error", "mb-3")
      response.messages.forEach(message => {
        this.flashTarget.insertAdjacentHTML("beforeend", message)
      })
      break
    }
  }

  // ジャンルを新規登録する処理
  genreCreate = (event) => {
    const genreElement = event.target
    fetch("/genre", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.head.querySelector("meta[name=csrf-token]")?.content
      },
      body: JSON.stringify({
        genre:{
          name: genreElement.value
        }
      })
    })
    .then(response => response.json())
    .then(data => {
      const genreId = `genre-${data.genre.id}`
      this.addFlash(data)
      this.addTopicGenre(genreId, data.genre.name)
      this.hideAndRemoveOptions()
      this.inputTarget.value = ""
    }) 
    .catch((error) => {
      alert("ジャンル登録に失敗しました。")
      console.error(error)
      this.hideAndRemoveOptions()
    })
  }

  // オートコンプリートの検索候補が表示しているか真偽を返す(ゲッター)
  get resultsShown() {
    return !this.resultsTarget.hidden
  }

  // オートコンプリートの表示を管理する(セッター)
  set resultsShown(value) {
    this.resultsTarget.hidden = !value
  }

  // レスポンスで返ってきたliタグの要素を配列で返す(role=option)
  get options() {
    return Array.from(this.resultsTarget.querySelectorAll(optionSelector))
  }
}

// デバウンスの定義(inputを入力して300ミリ秒)
const debounce = (fn, delay = 10) => {
  let timeoutId = null

  return (...args) => {
    clearTimeout(timeoutId)
    timeoutId = setTimeout(fn, delay)
  }
}
