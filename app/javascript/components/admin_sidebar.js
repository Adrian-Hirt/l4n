import Cookies from 'components/cookies'

export default class AdminSidebar {
  static addListener() {
    $('#offcanvas-sidebar-toggler').on('click', () => {
      $('body').addClass('sidebar-show');
    });

    $('.sidebar-backdrop').on('click', () => {
      $('body').removeClass('sidebar-show');
    });
  }
};