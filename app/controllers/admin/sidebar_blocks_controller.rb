module Admin
  class SidebarBlocksController < AdminController
    add_breadcrumb _('Admin|SidebarBlocks'), :admin_sidebar_blocks_path

    def index
      op Operations::Admin::SidebarBlock::Index
    end

    def new
      op Operations::Admin::SidebarBlock::Create
      add_breadcrumb _('Admin|SidebarBlock|New')
    end

    def create
      if run Operations::Admin::SidebarBlock::Create
        flash[:success] = _('Admin|SidebarBlock|Successfully created')
        redirect_to admin_sidebar_blocks_path
      else
        add_breadcrumb _('Admin|SidebarBlock|Edit')
        flash[:danger] = _('Admin|SidebarBlock|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::SidebarBlock::Update
      add_breadcrumb _('Admin|SidebarBlock|Edit')
    end

    def update
      if run Operations::Admin::SidebarBlock::Update
        flash[:success] = _('Admin|SidebarBlock|Successfully updated')
        redirect_to admin_sidebar_blocks_path
      else
        add_breadcrumb _('Admin|SidebarBlock|Edit')
        flash[:danger] = _('Admin|SidebarBlock|Edit failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::SidebarBlock::Destroy
        flash[:success] = _('Admin|SidebarBlock|Successfully deleted')
      else
        flash[:danger] = _('Admin|SidebarBlock|Cannot be deleted')
      end
      redirect_to admin_sidebar_blocks_path
    end
  end
end
