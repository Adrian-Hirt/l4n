module Lan
  class TimetableController < LanController
    skip_before_action :authenticate_user!

    def index
      op Operations::Lan::Timetable::Load
    end
  end
end
