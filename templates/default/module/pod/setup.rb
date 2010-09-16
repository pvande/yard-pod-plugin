include YARD::Templates::Helpers::PODHelper

include T('default/module/text')

def init
  sections :header
  sections << :synopsis if object.has_tag?(:example)
  sections.push(:description, [T('docstring')]) if has_long_description?(object)
  sections.push(:method_list, [ :group, [T('method')] ]) unless method_listing.empty?
  sections << :author if object.has_tag?(:author)
end

def group
  @group.sub!(/ Summary$/, 's') if @group =~ /^(Instance|Class) Method Summary$/
  erb(:group)
end

def has_long_description?(object)
  return !(
    object.docstring.empty? ||
    object.docstring.strip == object.docstring.summary
  )
end
