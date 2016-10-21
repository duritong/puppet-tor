module Puppet::Parser::Functions
  newfunction(:generate_onion_key, :type => :rvalue, :doc => <<-EOS
Generates or loads a rsa private key for an onion service, returns they onion
onion address and the private key content.

Requires a location to load and store the private key, as well an identifier, which will be used as a filename in the location.

Example:

    res = generate_onion_key('/tmp','my_secrect_key')
    notice "Onion Address: \${res[0]"
    notice "Priavte Key: \${res[1]"


If /tmp/my_secrect_key.key exists, it will be loaded and the onion address will be generated from it.

  EOS
  ) do |args|
    location = args.shift
    identifier = args.shift

    raise(Puppet::ParseError, "generate_onion_key(): requires 2 arguments") unless [location,identifier].all?{|i| !i.nil? }

    raise(Puppet::ParseError, "generate_onion_key(): requires location (#{location}) to be a directory") unless File.directory?(location)
    path = File.join(location,identifier)

    private_key = if File.exists?(path)
      pk = OpenSSL::PKey::RSA.new(File.read(path))
      raise(Puppet::ParseError, "generate_onion_key(): key in path #{path} must have a length of 1024bit") unless (pk.n.num_bytes * 8) == 1024
      pk
    else
      # 1024 is hardcoded by tor
      pk = OpenSSL::PKey::RSA.generate(1024)
      File.open(path,'w'){|f| f << pk.to_s }
      pk
    end

    [ function_onion_address([private_key]), private_key.to_s ]
  end
end
