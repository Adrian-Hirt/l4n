export default class PasswordVisibilityToggler {
  constructor(input) {
    this.input = input;
    this.toggler = $(input).next('.input-group-append');
    this.toggler.on('click', () => {
      this.toggleState();
    });
  }

  toggleState() {
    if (this.input.type == 'text') {
      this.input.type = 'password';
      this.toggler.find('svg').attr('data-icon', 'eye-slash');
    }
    else if (this.input.type == 'password') {
      this.input.type = 'text';
      this.toggler.find('svg').attr('data-icon', 'eye');
    }
  }
};