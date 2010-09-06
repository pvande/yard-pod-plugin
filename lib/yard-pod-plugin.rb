# @private
def __p(*path) File.join(File.dirname(__FILE__), 'yard', *path) end

module YARD
  module Serializers
    autoload :PODSerializer, __p('serializers', 'pod_serializer')
  end

  module Formatters
    autoload :PODFormatter, __p('formatters', 'pod_formatter')
  end

  module Templates
    module Helpers
      autoload :PODHelper, __p('templates', 'helpers', 'pod_helper')
    end

    Engine.register_template_path __p('..', '..', 'templates')
  end
end

undef __p
