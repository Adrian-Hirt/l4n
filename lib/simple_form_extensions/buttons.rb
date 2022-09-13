module Buttons
  def save(*args, &)
    options = args.extract_options!
    options[:class] ||= []
    options[:class] += %i[btn btn-primary]
    options[:name] = nil
    args << options
    submit(*args, &)
  end
end

SimpleForm::FormBuilder.include Buttons
