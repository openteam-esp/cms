class EnumInput < Formtastic::Inputs::SelectInput

  def collection
    @object.class.values_for_select_tag(method)
  end

  def wrapper_html_options
    super.merge(:class => 'enum select')
  end

  def input_html_options
    super.merge(:class => 'enum select')
  end

end
