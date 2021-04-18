import Cookies from 'components/cookies'

export default class AdminPushmenuToggler {
  static addListener() {
    $('#pushmenu_toggler').on('click', function() {
      if (Cookies.getCookie('_l4n_admin_sidebar_collapsed')) {
        Cookies.deleteCookie('_l4n_admin_sidebar_collapsed');
      }
      else {
        Cookies.setCookie('_l4n_admin_sidebar_collapsed', true, 365);
      }
    });
  }
};