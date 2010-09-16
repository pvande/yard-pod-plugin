include YARD::Templates::Helpers::PODHelper

include T('default/docstring/text')

def docstring_text
  text = super
  if object.type == :method
    return text
  else
    return text.sub(/^#{Regexp.escape(object.docstring.summary)}\s*/, '')
  end
end
