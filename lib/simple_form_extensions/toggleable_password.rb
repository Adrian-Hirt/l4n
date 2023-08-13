module ToggleablePassword
  def password(*, **kwargs, &)
    kwargs[:append] = '<i class="fa fa-eye-slash fa-fw"></i>'.html_safe
    kwargs[:append_options] = {
      data: {
        'toggleable-password-target' => 'button',
        action: 'click->toggleable-password#toggle'
      }
    }
    kwargs[:wrapper_html] ||= {}
    kwargs[:wrapper_html][:data] = {
      controller: 'toggleable-password'
    }
    kwargs[:input_html] ||= {}
    kwargs[:input_html][:data] = {
      'toggleable-password-target' => 'input'
    }
    input(*, **kwargs, &)
  end
end

SimpleForm::FormBuilder.include ToggleablePassword
