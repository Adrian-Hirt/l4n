module Admin
  class StartpageBlocksController < AdminController
    add_breadcrumb _('Admin|StartpageBlocks'), :admin_startpage_blocks_path

    def index
      op Operations::Admin::StartpageBlock::Index
    end

    def new
      op Operations::Admin::StartpageBlock::Create
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('StartpageBlock') }
    end

    def create
      if run Operations::Admin::StartpageBlock::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('StartpageBlock') }
        redirect_to admin_startpage_blocks_path
      else
        add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('StartpageBlock') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('StartpageBlock') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::StartpageBlock::Update
      add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('StartpageBlock') }
    end

    def update
      if run Operations::Admin::StartpageBlock::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('StartpageBlock') }
        redirect_to admin_startpage_blocks_path
      else
        add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('StartpageBlock') }
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('StartpageBlock') }
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::StartpageBlock::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('StartpageBlock') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('StartpageBlock') }
      end
      redirect_to admin_startpage_blocks_path
    end
  end
end
