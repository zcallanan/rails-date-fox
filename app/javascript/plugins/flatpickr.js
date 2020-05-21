import flatpickr from 'flatpickr'
// import 'flatpickr/dist/themes/dark.css'
import 'flatpickr/dist/flatpickr.min.css'

flatpickr(".datepicker", {
  altInput: true,
  enableTime: true,
  minDate: "today",
  time_24hr: true
});
