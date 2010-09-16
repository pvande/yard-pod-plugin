include YARD::Templates::Helpers::PODHelper

def init
  sections :name, :header, T('docstring')
  sections.place(:aliases).after(:name) unless object.aliases.empty?
end

def name
  "=item B<<<< #{object.name} >>>>\n\n"
end

def header
  if object.has_tag?(:overload)
    object.tags(:overload).collect do |obj|
      @object = obj
      erb(:signature).rstrip
    end.join("\n") << "\n\n"
  else
    erb(:signature)
  end
end