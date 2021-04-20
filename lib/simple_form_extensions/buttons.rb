module Buttons
  def save(*args, &block)
    options = args.extract_options!
    options[:class] = %i[btn btn-primary]
    options[:name] = nil
    args << options
    submit(*args, &block)
  end
end

SimpleForm::FormBuilder.include Buttons
