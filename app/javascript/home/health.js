import "application"

function setButton(){
  const b = document.getElementById('errorButton');
  b.addEventListener("click", function(e) {
    console.log('clicked the button')
    myUndefinedFunctionChessResult();
  });
}

window.addEventListener("load", (event) => {
  console.log('hello health page')
  setButton()
});