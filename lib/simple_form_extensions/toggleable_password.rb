module ToggleablePassword
  def password(*args, **kwargs, &block)
    kwargs[:append] = '<i class="fa fa-eye-slash fa-fw"></i>'.html_safe
    kwargs[:append_options] = {
      data: {
        'toggleable-password-target' => 'button',
        action: 'click->toggleable-password#toggle'
      }
    }
    kwargs[:wrapper_html] ||= {}
    kwargs[:wrapper_html].merge!({
                                 data: {
                                   controller:  'toggleable-password'
                                 }
                               })
    kwargs[:input_html] ||= {}
    kwargs[:input_html].merge!({
      data: {
        'toggleable-password-target' => 'input'
      }
    })
    input(*args, **kwargs, &block)
  end
end

SimpleForm::FormBuilder.include ToggleablePassword
