const progress = () => {
  const steps = document.querySelectorAll('.task');
  const url = window.location.pathname.split("/");

    steps.forEach((step) => {
      step.classList.remove('active-step')
    });
   
    if (url[3] == 'cities') {
      steps[0].classList.add('active-step')
    }
    if (url[3] == 'date_times') {
      steps[0].classList.add('active-step')
      steps[1].classList.add('active-step')
    }
    if (url[3] == 'activities') {
      steps[0].classList.add('active-step')
      steps[1].classList.add('active-step')
      steps[2].classList.add('active-step')
    }
    if (url[3] == 'price_ranges') {
      steps[0].classList.add('active-step')
      steps[1].classList.add('active-step')
      steps[2].classList.add('active-step')
      steps[3].classList.add('active-step')
    }

};

export { progress }
