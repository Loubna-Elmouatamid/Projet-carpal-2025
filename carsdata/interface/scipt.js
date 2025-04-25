
function showLoader() {
    document.getElementById("loader").style.display = "flex";
    document.getElementById("wrapper").style.display = "none";
  }
  
  
  function hideLoader() {
    document.getElementById("loader").style.display = "none";
    document.getElementById("wrapper").style.display = "block";
  }
  
  
  setTimeout(function() {
    hideLoader();
  }, 3000);
  const wrapper = document.querySelector('.wrapper');
  const registerLink = document.querySelector('.register-link');
  const loginLink = document.querySelector('.login-link');

  registerLink.onclick = () => {
      wrapper.classList.add('active');
  }

  loginLink.onclick = () => {
      wrapper.classList.remove('active');
  }