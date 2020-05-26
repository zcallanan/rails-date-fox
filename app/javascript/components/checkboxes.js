// Mulitselect only for actvities (checkboxes)
const choice = () => {
  const choice = document.querySelectorAll('.choice');

  choice.forEach((choice) => {
    choice.addEventListener("click", (event) => {
      event.currentTarget.classList.toggle("active");
    });
  });

};


// Adding a class to an element and removing it from the previous one
const select_city = () => {
  const cities = document.querySelectorAll('.city');

    cities.forEach((city) => {
      
      city.addEventListener('click', (event) => {
        cities.forEach((city) => {
          city.classList.remove("activated")
        });
        // if (event.currentTarget.classList.contains('active')) {
        //   event.currentTarget.classList.remove("active")
        // };
        event.currentTarget.classList.add("activated"); 
      });

    });
    
};

// Select price range

const select_price = () => {
  const price_range = document.querySelectorAll('.price-choice');

    price_range.forEach((price) => {
      
      price.addEventListener('click', (event) => {
        price_range.forEach((price) => {
          price.classList.remove("active")
        });
        event.currentTarget.classList.add("active"); 
      });

    });
    
};


export { choice }
export { select_city }
export { select_price }
