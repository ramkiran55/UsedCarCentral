const form = document.querySelector('#registration-form');
const usernameInput = document.querySelector('#username');
const emailInput = document.querySelector('#email');
const passwordInput = document.querySelector('#password');
const passwordFeedback = document.querySelector('#password-feedback');

form.addEventListener('submit', (event) => {
  event.preventDefault();

  if (!validateUsername()) {
    return;
  }

  if (!validateEmail()) {
    return;
  }

  if (!validatePassword()) {
    return;
  }

  // submit the form
  form.submit();
});

function validateUsername() {
  const username = usernameInput.value.trim();
  const regex = /^[a-zA-Z0-9_-]{3,16}$/;

  if (!regex.test(username)) {
    alert('Username must be 3-16 characters long and can only contain letters, numbers, underscores, and hyphens.');
    return false;
  }

  return true;
}

function validateEmail() {
  const email = emailInput.value.trim();
  const regex = /^\S+@\S+\.\S+$/;

  if (!regex.test(email)) {
    alert('Please enter a valid email address.');
    return false;
  }

  return true;
}

function validatePassword() {
  const password = passwordInput.value.trim();

  if (password.length < 8) {
    passwordFeedback.textContent = 'Password must be at least 8 characters long.';
    return false;
  }

  if (!/\d/.test(password)) {
    passwordFeedback.textContent = 'Password must contain at least one number.';
    return false;
  }

  if (!/[a-zA-Z]/.test(password)) {
    passwordFeedback.textContent = 'Password must contain at least one letter.';
    return false;
  }

  passwordFeedback.textContent = '';
  return true;
}
