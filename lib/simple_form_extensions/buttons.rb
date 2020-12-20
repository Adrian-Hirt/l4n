module Buttons
  def save(*args, &block)
    template.content_tag :div, class: 'form-group' do
      template.content_tag :div, class: 'col-sm-offset-4 col-sm-10' do
        options = args.extract_options!
        options[:class] = %i[btn btn-primary]
        options[:name] = nil
        args << options
        submit(*args, &block)
      end
    end
  end
end

SimpleForm::FormBuilder.include Buttons
