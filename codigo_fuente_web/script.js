document.querySelectorAll('.accordion').forEach((button) => {
  button.addEventListener('click', () => {
    const panel = document.getElementById(button.getAttribute('aria-controls'));
    const isOpen = button.getAttribute('aria-expanded') === 'true';
    button.setAttribute('aria-expanded', String(!isOpen));
    panel.classList.toggle('open', !isOpen);
  });
});
document.querySelectorAll('.filter').forEach((button) => {
  button.addEventListener('click', () => {
    document.querySelectorAll('.filter').forEach((item) => item.classList.remove('active'));
    button.classList.add('active');
    const category = button.dataset.filter;
    document.querySelectorAll('.skill').forEach((skill) => {
      const visible = category === 'all' || skill.dataset.category === category;
      skill.classList.toggle('hidden', !visible);
    });
  });
});
const form = document.getElementById('contactForm');
const status = document.getElementById('formStatus');
form.addEventListener('submit', (event) => {
  event.preventDefault();
  if (!form.checkValidity()) {
    status.textContent = 'Revisa los campos: hay información incompleta o no válida.';
    form.reportValidity();
    return;
  }
  status.textContent = 'Formulario validado correctamente. Esta demostración no envía datos.';
  form.reset();
});
window.setAppTheme = function (darkMode) {
  document.documentElement.classList.toggle('dark', Boolean(darkMode));
};