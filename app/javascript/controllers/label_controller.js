import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["combobox"]

  connect() {
    this.comboboxTarget.addEventListener("blur", this.assignLabel.bind(this))
  }

  assignLabel(event) {
    const labelName = event.target.value
    console.log(labelName)
    if (labelName) {
      const listId = this.data.get("listId")
      const itemId = this.data.get("itemId")
      const url = `/lists/${listId}/items/${itemId}/assign_label/${labelName}`
      console.log(url)

      fetch(url, {
        method: 'PATCH',
        contentType: "application/json",
        responseKind: "turbo-stream",
        headers: {
          'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content')
        }
      })
    }
  }

}
