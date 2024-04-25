import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      onEnd: this.end.bind(this)
    })
  }

  end(event) {
    let id = event.item.dataset.id;
    let data = new FormData();
    data.append("position", event.newIndex + 1);
    let url = this.data.get("url").replace(":id", id);

    fetch(url, {
      method: 'PATCH',
      body: data,
      headers: {
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content')
      }
    }).then(response => {
      if (response.ok) {
        console.log('Update successful');
      } else {
        console.error('Update failed');
      }
    }).catch(error => {
      console.error('Error:', error);
    });
}

}
