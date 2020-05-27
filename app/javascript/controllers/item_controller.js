// import Rails from '@rails/ujs';

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'name', 'alias', 'photo' ];

  connect() {
    console.log('Hello!');
  }

  refresh() {
    const element = document.getElementById('replace')
    const itemId = element.dataset.itemId
    const searchId = element.dataset.searchId
    const searchUrl = this.data.get('refresh-url')
    const data = {itemId: itemId}

    const url = `/searches/${searchId}/refresh`;
    fetch(searchUrl, {
      method: 'POST',
      headers: {
        accept: 'application/json',
        'content-type': 'application/json',
        'X-CSRF-Token': Rails.csrfToken()
      },
      body: JSON.stringify(data)
    })
      .then(response => response.json())
      .then((data) => {
        console.log(data);
      });

  }
}
