import Cookies from 'components/cookies'

export default class AdminSidebar {
  static addListener() {
    $('#offcanvas-sidebar-toggler').on('click', () => {
      $('body').addClass('sidebar-show');
    });

    $('#collapses-sidebar-toggler').on('click', () => {
      $('#sidebar').toggleClass('collapsed');
    });

    $('.sidebar-backdrop').on('click', () => {
      $('body').removeClass('sidebar-show');
    });
  }
};