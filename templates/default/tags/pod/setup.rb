include YARD::Templates::Helpers::PODHelper

include T('default/tags/text')

def init
  super
  tags = sections.last
  tags.delete(:example) unless object.type == :method
  tags.delete(:author)  unless object.type == :method
end

def example
  return unless object.has_tag?(:example)
  
  output = ""
  object.tags(:example).each do |tag|
    output << "# #{tag.name}\n" unless tag.name.empty?
    output << format_source(tag.text) << "\n"
    output << "\n"
  end
  return "Examples:\n\n" << indent(output.strip + "\n")
end

def see
  erb(:see) if object.has_tag?(:see)
end

def tag_text(tag)
  text = "=item *\n\n"
  text << format_types(tag.types) << " " unless @no_types || tag.types.nil?
  text << 'B<<<<< C<<<< ' << tag.name.to_s << " >>>> >>>>> " unless @no_names
  text << "-- " unless tag.text.nil? || (tag.name.nil? && tag.types.nil?) || @no_names && @no_types
  text << podify(tag.text) if tag.text && !tag.text.empty?
  return text
end

def option_text(tag)
  text = "=item *\n\n"
  text << format_types(tag.pair.types) << ' ' if tag.pair.types
  text << "B<<<<< " << tag.pair.name.to_s << " >>>>> "
  text << "-- " << tag.pair.text if tag.pair.text
  if tag.pair.defaults
    text << "  Defaults to " << tag.pair.defaults.map do |default|
      default =~ /\s/ ? podify(default) : "C<<<<< #{default} >>>>>"
    end.join(" or ") << '.'
  end
  return text
end
