import { Controller } from "@hotwired/stimulus"

const optionSelector = "[role='option']:not([aria-disabled])"
const activeSelector = "[aria-selected='true']"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["input", "hidden", "results"]
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
    this.resultsTarget.addEventListener("click", this.onResultsClick)

    if (this.inputTarget.hasAttribute("autofocus")) {
      this.inputTarget.focus()
    }

    this.readyValue = true
  }

  disconnect() {
    if (this.hasInputTarget) {
      this.inputTarget.removeEventListener("keydown", this.onKeydown)
      this.inputTarget.removeEventListener("blur", this.onInputBlur)
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

    // selectedのElementがaタグの場合、link先に移行する処理を書いて,コントローラをクローズする
    if (selected instanceof HTMLAnchorElement) {
      selected.click()
      this.close()
      return
    }

    // data-autocomplete-labelに値があれば取得する。なければターゲット内で定義している文字列を取得
    const textValue = selected.getAttribute("data-autocomplete-label") || selected.textContent.trim()
    // data-autocomplete-valueに値があれば取得する。なければtextValueと同じ値を取得
    const value = selected.getAttribute("data-autocomplete-value") || textValue
    // text_fieldに値を入力
    this.inputTarget.value = textValue

    // inputにhiddenを定義している場合、処理を実行
    if (this.hasHiddenTarget) {
      // hidden要素にvalueの値を代入
      this.hiddenTarget.value = value
      // hidden要素にinputとchangeイベントを起動させる(理解出来てない)
      this.hiddenTarget.dispatchEvent(new Event("input"))
      this.hiddenTarget.dispatchEvent(new Event("change"))
    } else {
      // hiddenが無い場合、inputの初期値にvalueを代入する
      this.inputTarget.value = value
    }
    // inputにフォーカスを設定する
    this.inputTarget.focus()
    this.hideAndRemoveOptions()

    this.element.dispatchEvent(
      new CustomEvent("autocomplete.change", {
        bubbles: true,
        detail: { value: value, textValue: textValue, selected: selected }
      })
    )
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

  // inputの入力が無い場合、コントローラの情報をリセットする
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
    this.identifyOptions()
    if (!!this.options) {
      this.open()
    } else {
      this.close()
    }
  }

  // レスポンスで渡されたlistタグに一意なidを付与
  identifyOptions() {
      const prefix = this.resultsTarget.id || "stimulus-autocomplete"
      const optionsWithoutId = this.resultsTarget.querySelectorAll(`${optionSelector}:not([id])`)
      optionsWithoutId.forEach(el => el.id = `${prefix}-option-${this.constructor.uniqOptionId++}`)
  }

  // オートコンプリート表示を展開させる処理
  open() {
    if (this.resultsShown) return

    this.resultsShown = true
    this.element.setAttribute("aria-expanded", "true")
    this.element.dispatchEvent(
      new CustomEvent("toggle", {
        detail: { action: "open", inputTarget: this.inputTarget, resultsTarget: this.resultsTarget }
      })
    )
  }

  // オートコンプリート表示を終了させる処理
  close() {
    if (!this.resultsShown) return

    this.resultsShown = false
    this.inputTarget.removeAttribute("aria-activedescendant")
    this.element.setAttribute("aria-expanded", "false")
    this.element.dispatchEvent(
      new CustomEvent("toggle", {
        detail: { action: "close", inputTarget: this.inputTarget, resultsTarget: this.resultsTarget }
      })
    )
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
