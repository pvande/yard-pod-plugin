require 'rdoc/markup/to_html'

module YARD
  module Formatters
    class PODFormatter < RDoc::Markup::ToHtml
      def initialize(object)
        super()
        @package = object.type == :method ? object.namespace : object
      end

      attr_accessor :package

      def init_tags
        add_tag :BOLD, 'B<<<< ', ' >>>>'
        add_tag :EM,   'I<<<< ', ' >>>>'
        add_tag :TT,   'C<<<< ', ' >>>>'
        @markup.add_special(/[A-Z]</, :POD_COMMAND)
        @markup.add_special(/\{(\S+?)\}/m, :YARDLINK)
      end

      def handle_special_POD_COMMAND(tag)
        text = tag.text
        text[1..-1] = "Z<>"
        text
      end

      def handle_special_HYPERLINK(link)
        "L<<<< S<<<<< #{link.text} >>>>> >>>>"
      end

      def handle_special_YARDLINK(link)
        link = link.text[/.(.*)./, 1]
        ref  = P(link).to_s.sub('#', '/').strip
        ref.sub!(/^\//, "#{package}/")
        "L<<<< S<<<<< #{link} >>>>>|#{ ref.strip } >>>>"
      end

      def handle_special_TIDYLINK(special)
        text = special.text
        return text unless text =~ /\{(.*?)\}\[(.*?)\]/ or text =~ /(\S+)\[(.*?)\]/
        return "L<<<< S<<<<< #{name=$1} >>>>>|#{link=$2} >>>>"
      end

      def accept_paragraph(p)
        @res << convert_flow(@am.flow(p.text)) << "\n"
      end

      def accept_blank_line(line)
        @res << "\n"
      end

      # def accept_heading(head)
      #   @res << '=head' << head.level.to_s << ' '
      #   @res << head.text << "\n"
      # end

      def accept_verbatim(txt)
        @res << txt.text << "\n"
      end

      def accept_list_start(list)
        @type ||= []
        @counts ||= []
        @type << list.type
        @counts << 0
        @res << "\n\n" << '=over' <<"\n\n"
      end

      def accept_list_item_start(list)
        @res << case @type.last
        when :BULLET
          '=item *'
        when :NUMBER, :LALPHA, :UALPHA
          @counts[-1] += 1
          "=item #{@counts.last}"
        else
          "=item B<<<<< " << convert_flow(@am.flow(list.label)) << " >>>>>"
        end << "\n\n"
      end

      def accept_list_item_end(list)
        @res << "\n\n"
      end

      def accept_list_end(list)
        [@type, @counts].each(&:pop)
        @res << '=back' << "\n\n"
      end

      def convert_string(text)
        text.gsub(/\+(?! )([^\n\+]{1,900})(?! )\+/) do
          type_text, pre_text, no_match = $1, $`, $&
          pre_match = pre_text.scan(%r(C<+|>+))
          unless pre_match.last && pre_match.last.start_with?('C')
            'C<<<< ' + type_text + ' >>>>'
          else
            no_match
          end
        end
      end
    end
  end
end