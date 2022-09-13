module TurboForm
  # See https://github.com/hotwired/turbo/issues/138#issuecomment-847699281
  def simple_form_for(record, options = {}, &)
    options[:data] ||= {}
    options[:data]['turbo-frame'] = '_top'

    super(record, options, &)
  end
end

module SimpleForm
  module ActionViewExtensions
    module FormHelper
      prepend TurboForm
    end
  end
end
