const channels = require.context('.', true, /_channel\.js$/)
channels.keys().forEach(channels)

// // Get the modal
const modal = document.querySelector(".modal");

// Get the button that opens the modal
const btns = document.querySelectorAll(".status-btn");

// Get the form to listen for a submit event
let form = document.querySelector('form');

// This is let as they need to be reassigned when the popup comes up. Unsure why it isn't seen if hidden
let save = document.getElementById("save-button");

// This is the item object that was clicked for reference when we need to change the status
let itemBeingChanged;


function handleModal(e){
  modal.style.display = "block";
  itemBeingChanged = this;
  //resave these vars, as far as i can tell, they weren't on the page during render. Only when the modal is clicked
  let save = document.getElementById("save-button");
};

function updateStatus(e) {
  //finds the radio button status that was pushed
  let element = document.getElementsByName('result');
  var statusVal;
  for(i = 0; i < element.length; i++) {
    if(element[i].checked)
      var statusVal = element[i].value;
  };
  console.log(statusVal);
  console.log(itemBeingChanged.dataset.item);
  e.preventDefault();

  //NOT CURRENTLY FUNCTIONAL. Fetch won't work on localhost or Ngrok. The only solution I see is to push this to production and use the live url.
  //This sends data to the orders#update_status action. This will do a PUT request to the api updating the items status.
  // If this was a React app as well, this could re-render the status component... but since it is just rails the whole page
  // would need to re-render to update the status
  // fetch("https://realhub-rails-test.herokuapp.com/", {
  //   mode: 'no-cors',
  //    method: 'POST',
  //    body: JSON.stringify({
  //       item_id: itemBeingChanged.dataset.item,
  //       new_status: statusVal,
  //    })
  // });
};

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modal) {
    modal.style.display = "none";
  }
}

// When the user clicks on save button the modal closes
save.onclick = function() {
  modal.style.display = "none";
}

btns.forEach(btn => btn.addEventListener('click', handleModal));
form.addEventListener('submit', updateStatus);

