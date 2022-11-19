module Admin
  class StartpageBlocksController < AdminController
    add_breadcrumb _('Admin|StartpageBlocks'), :admin_startpage_blocks_path

    def index
      op Operations::Admin::StartpageBlock::Index
    end

    def new
      op Operations::Admin::StartpageBlock::Create
      add_breadcrumb _('Admin|StartpageBlock|New')
    end

    def create
      if run Operations::Admin::StartpageBlock::Create
        flash[:success] = _('Admin|StartpageBlock|Successfully created')
        redirect_to admin_startpage_blocks_path
      else
        add_breadcrumb _('Admin|StartpageBlock|Edit')
        flash[:danger] = _('Admin|StartpageBlock|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::StartpageBlock::Update
      add_breadcrumb _('Admin|StartpageBlock|Edit')
    end

    def update
      if run Operations::Admin::StartpageBlock::Update
        flash[:success] = _('Admin|StartpageBlock|Successfully updated')
        redirect_to admin_startpage_blocks_path
      else
        add_breadcrumb _('Admin|StartpageBlock|Edit')
        flash[:danger] = _('Admin|StartpageBlock|Edit failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::StartpageBlock::Destroy
        flash[:success] = _('Admin|StartpageBlock|Successfully deleted')
      else
        flash[:danger] = _('Admin|StartpageBlock|Cannot be deleted')
      end
      redirect_to admin_startpage_blocks_path
    end
  end
end
