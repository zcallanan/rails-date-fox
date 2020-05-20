// import noUiSlider from 'nouislider';
// import { Controller } from "stimulus";

// export default class extends Controller {
//   static targets = [ 'search-form-container', 'min', 'max' ];

//   connect() {
//     console.log("hello from range slider controller");

//     this.slider = noUiSlider.create(this.search-form-containerTarget, {
//       start: this.startValue,
//       connect: true,
//       range: {
//         'min': 0,
//         'max': 5
//       },
//       step: 1,
//       format: {
//         to: value => value.toString().split('.')[0],
//         from: value => Number(value.replace(',-', ''))
//       }
//     })

//     this.slider.on('slide', this.updateInputs.bind(this));
//   }
// } 