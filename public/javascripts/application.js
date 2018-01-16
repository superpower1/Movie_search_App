const button = document.querySelector('.search-box button');
const searchInput = document.querySelector('.search-input');
searchInput.addEventListener('keyup', e=>{
  if (e.target.value === "") {
    button.classList.add('hidden');
  } else {
    button.classList.remove('hidden');
  }
});
