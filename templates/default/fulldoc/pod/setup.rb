def init
  objects = run_verifier(options.delete(:objects)).reject { |e| e.type == :root }
  options[:serializer] = Serializers::PODSerializer.new(options[:serializer].options)

  objects.each { |obj| serialize(obj) }
end

def serialize(object)
  options[:object] = object
  Templates::Engine.with_serializer(options[:object], options[:serializer]) do
    <<-POD +
=for comment Documentation generated by YARD v#{YARD::VERSION} and yard-pod-plugin v#{YARD::Serializers::PODSerializer::VERSION}.

    POD
    T(object.type).run(options)
  end
end
