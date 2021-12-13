module TurboForm
  # See https://github.com/hotwired/turbo/issues/138#issuecomment-847699281
  def simple_form_for(record, options = {}, &block)
    options[:data] ||= {}
    options[:data].merge!('turbo-frame' => '_top')

    super(record, options, &block)
  end
end

module SimpleForm
  module ActionViewExtensions
    module FormHelper
      prepend TurboForm
    end
  end
end
