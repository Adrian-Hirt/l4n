module Admin
  class SidebarBlocksController < AdminController
    add_breadcrumb _('Admin|SidebarBlocks'), :admin_sidebar_blocks_path

    def index
      op Operations::Admin::SidebarBlock::Index
    end

    def new
      op Operations::Admin::SidebarBlock::Create
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('SidebarBlock') }
    end

    def create
      if run Operations::Admin::SidebarBlock::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('SidebarBlock') }
        redirect_to admin_sidebar_blocks_path
      else
        add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('SidebarBlock') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('SidebarBlock') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::SidebarBlock::Update
      add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('SidebarBlock') }
    end

    def update
      if run Operations::Admin::SidebarBlock::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('SidebarBlock') }
        redirect_to admin_sidebar_blocks_path
      else
        add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('SidebarBlock') }
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('SidebarBlock') }
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::SidebarBlock::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('SidebarBlock') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('SidebarBlock') }
      end
      redirect_to admin_sidebar_blocks_path
    end
  end
end
