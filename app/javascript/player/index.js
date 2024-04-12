import "application"

function setSubmit(){
  const form = document.getElementById('rankingForm');
  const kindField = document.getElementById('kindField');
  form.addEventListener("submit", (event) => {
    // set kind
    let kind = "games";
    const commitId = event.submitter.id
    if(commitId === 'gamesSubmit'){
      kind = 'games'
    }else if(commitId === 'winSubmit'){
      kind = 'win'
    }else if(commitId === 'drawSubmit'){
      kind = 'draw'
    }else if(commitId === 'avgRatingSubmit'){
      kind = 'avg_rating'
    }
    kindField.value = kind;
  })

}

window.addEventListener("load", (event) => {
  console.log('hello index js');
  setSubmit();
});