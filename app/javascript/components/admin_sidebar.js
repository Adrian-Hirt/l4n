import Cookies from 'components/cookies'

export default class AdminSidebar {
  static addListener() {
    $('#offcanvas-sidebar-toggler').on('click', () => {
      $('body').addClass('sidebar-show');
    });

    $('#collapses-sidebar-toggler').on('click', () => {
      let sidebar = $('#sidebar');
      if(sidebar.hasClass('sidebar-collapsed')) {
        sidebar.removeClass('sidebar-collapsed');
        Cookies.deleteCookie('_l4n_admin_sidebar_collapsed');
      }
      else {
        sidebar.addClass('sidebar-collapsed');
        Cookies.setCookie('_l4n_admin_sidebar_collapsed', true, 365);
      }
    });

    $('.sidebar-backdrop').on('click', () => {
      $('body').removeClass('sidebar-show');
    });
  }
};