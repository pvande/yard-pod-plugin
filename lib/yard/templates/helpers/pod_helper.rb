require 'cgi'

module YARD
  module Templates::Helpers
    module PODHelper
      include BaseHelper
      include TextHelper

      def podify(str)
        Formatters::PODFormatter.new(object).convert(str)
      end

      def signature(meth)
        # use first overload tag if it has a return type and method itself does not
        if !meth.tag(:return) && meth.tag(:overload) && meth.tag(:overload).tag(:return)
          meth = meth.tag(:overload)
        end

        type = options[:default_return] || ""
        if meth.tag(:return) && meth.tag(:return).types
          types = meth.tags(:return).map {|t| t.types ? t.types : [] }.flatten.uniq
          first = types.first
          if types.size == 2 && types.last == 'nil'
            type = first + '?'
          elsif types.size == 2 && types.last =~ /^(Array)?<#{Regexp.quote types.first}>$/
            type = first + '+'
          elsif types.size > 2
            type = [first, '...'].join(', ')
          elsif types == ['void'] && options[:hide_void_return]
            type = ""
          else
            type = types.join(", ")
          end
        end
        type = "(#{type})" if type.include?(',')
        type = " # => #{type} " unless type.empty?
        scope = '' or meth.scope == :class ? "+ " : "- "
        name = meth.name
        blk = format_block(meth)
        args = format_args(meth)
        extras = []
        extras_text = ''
        if rw = meth.namespace.attributes[meth.scope][meth.name]
          attname = [rw[:read] ? 'read' : nil, rw[:write] ? 'write' : nil].compact
          attname = attname.size == 1 ? attname.join('') + 'only' : nil
          extras << attname if attname
        end
        extras << meth.visibility if meth.visibility != :public
        extras_text = "# #{extras.join(", ")}\n" unless extras.empty?
        title = "%s%s%s%s %s%s" % [extras_text, scope, name, args, blk, type]
        title.gsub(/ +/, ' ')
      end

      def format_types(list, brackets = true)
        return "" if list.nil? || list.empty?
        list = "I<<<< #{list.join(", ")} >>>>"
        brackets ? "(#{list})" : list
      end
    end
  end
end