const activities = () => {
  const cb_activity = document.querySelector('.activity-choice');

  cb_activity.addEventListener('click', (event) => {
    event.currentTarget.classList.toggle("active");
  });
};

const price_range = () => {
  const cb_price = document.querySelector('.price-choice');

  cb_price.addEventListener('click', (event) => {
    event.currentTarget.classList.toggle("active");
  });
};

export { activities, price_range }

// Checkbox
