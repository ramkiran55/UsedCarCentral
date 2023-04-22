const form = document.querySelector('form');
const passwordInput = document.querySelector('input[name="password"]');
const passwordValidation = document.querySelector('#password-validation');
const emailInput = document.querySelector('input[name="email"]');
const emailValidation = document.querySelector('#email-validation');

form.addEventListener('submit', function(event) {
    if (!emailInput.value.trim() || !passwordInput.value.trim()) {
        alert('Please enter both email and password!');
        event.preventDefault();
      }
  
  const passwordValue = passwordInput.value.trim();
  const emailValue = emailInput.value.trim();

  // Check if password is at least 8 characters long
    if (passwordValue.length < 8) {
        passwordInput.classList.add('invalid');
        passwordValidation.textContent = 'Password must be at least 8 characters long.';
        passwordValidation.style.color = 'red';
    } else {
        passwordInput.classList.remove('invalid');
        passwordValidation.textContent = '';
    }

    // Check if email is valid
    if (!isValidEmail(emailValue)) {
        emailInput.classList.add('invalid');
        emailValidation.textContent = 'Please enter a valid email address.';
        emailValidation.style.color = 'red';
    } else {
        emailInput.classList.remove('invalid');
        emailValidation.textContent = '';
    }
});

function isValidEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}
