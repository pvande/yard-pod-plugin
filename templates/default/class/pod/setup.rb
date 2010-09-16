include YARD::Templates::Helpers::PODHelper

include T('default/module/pod')
include T('default/class/text')

def init
  super
  sections.place(:inheritance).after(:header)
end

def inheritance
  erb(:inheritance) if object.superclass != P(:Object)
end

# 
# def init
#   options[:format] = :text  # Tell ERB to supress newlines
#   @description = desc(object, true)
# 
#   sections :header# :bugs
#   sections << :synopsis    if object.has_tag?(:example)
#   sections << :description unless @description.empty?
#   sections << :inheritance unless object.superclass == P(:Object)
#   sections << :method_listing
#   sections << :author      if object.has_tag?(:author)
# end
# 
# def method_listing
#   options[:format] = :pod
#   return T('methods').run(options.merge(:object => object))
# ensure
#   options[:format] = :text
# end
# 
# def sort_listing(list)
#   list.sort_by { |o| [ o.scope.to_s, o.name.to_s.downcase ] }
# end
