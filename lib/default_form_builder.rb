# -*- coding: utf-8 -*-

class DefaultFormBuilder < ActionView::Helpers::FormBuilder
  def error(attribute, attr_name = nil, error_name = :invalid, options = {})
    html_options = options.stringify_keys
    html_options.reverse_merge!({ 'class' => 'error' })
    case attr_name
    when Symbol
      attr_name = object.class.human_attribute_name(attr_name)
    when String
      attr_name = attr_name
    else
      attr_name = object.class.human_attribute_name(attribute)
    end
    content = attr_name + I18n.t("errors.messages.#{error_name}")
    label(attribute, content, html_options)
  end

  def label(attribute, attr_name = nil, options = {})
    html_options = options.stringify_keys
    case attr_name
    when Symbol
      attr_name = object.class.human_attribute_name(attr_name)
    when String
      # do nothing
    else
      attr_name = object.class.human_attribute_name(attribute)
    end
    super(attribute, attr_name, html_options)
  end

  def submit(value = nil, options = {})
    value, options = nil, value if value.is_a?(Hash)
    value ||= submit_default_value
    options = options.stringify_keys
    options.reverse_merge!(
      'class' => 'btn send',
      'data-disable-with' => I18n.t('actions.saving')
    )
    @template.submit_tag(value, options)
  end
end
