module Lan
  class TimetableController < LanController
    skip_before_action :authenticate_user!

    add_breadcrumb _('Timetable')

    def index
      op Operations::Lan::Timetable::Load
    end
  end
end
