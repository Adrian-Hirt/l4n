import { Controller } from "@hotwired/stimulus"
import Cookies from '../../components/cookies'

export default class extends Controller {
  static targets = ['sidebar'];

  collapseSidebar() {
    if(this.sidebarTarget.classList.contains('sidebar-collapsed')) {
      this.sidebarTarget.classList.remove('sidebar-collapsed');
      Cookies.deleteCookie('_l4n_admin_sidebar_collapsed');
    }
    else {
      this.sidebarTarget.classList.add('sidebar-collapsed');
      Cookies.setCookie('_l4n_admin_sidebar_collapsed', true, 365);
    }
  }

  showOffcanvasSidebar() {
    document.body.classList.add('sidebar-show');
  }

  hideOffcanvasSidebar() {
    document.body.classList.remove('sidebar-show');
  }
}
