const choice = () => {
  const cb_activity = document.querySelectorAll('.choice');

  cb_activity.forEach((choice) => {
    choice.addEventListener("click", (event) => {
      event.currentTarget.classList.toggle("active");
    });
  });

};

export { choice }

