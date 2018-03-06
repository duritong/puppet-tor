module Puppet::Parser::Functions
  newfunction(:generate_onion_key, :type => :rvalue, :doc => <<-EOS
Generates or loads a rsa private key for an onion service, returns they onion
onion address and the private key content.

Requires a location to load and store the private key, as well an identifier, which will be used as a filename in the location.

Example:

    res = generate_onion_key('/tmp','my_secret_key')
    notice "Onion Address: \${res[0]"
    notice "Priavte Key: \${res[1]"


It will also store the onion address under /tmp/my_secret_key.hostname.
If /tmp/my_secret_key.key exists, but not the hostname file. Then the function will be loaded and the onion address will be generated from it.

  EOS
  ) do |args|
    location = args.shift
    identifier = args.shift

    raise(Puppet::ParseError, "generate_onion_key(): requires 2 arguments") unless [location,identifier].all?{|i| !i.nil? }

    raise(Puppet::ParseError, "generate_onion_key(): requires location (#{location}) to be a directory") unless File.directory?(location)
    path = File.join(location,identifier)

    private_key = if File.exists?(kf="#{path}.key")
      pk = OpenSSL::PKey::RSA.new(File.read(kf))
      raise(Puppet::ParseError, "generate_onion_key(): key in path #{kf} must have a length of 1024bit") unless (pk.n.num_bytes * 8) == 1024
      pk
    else
      # 1024 is hardcoded by tor
      pk = OpenSSL::PKey::RSA.generate(1024)
      File.open(kf,'w'){|f| f << pk.to_s }
      pk
    end
    onion_address = if File.exists?(hf="#{path}.hostname")
      File.read(hf)
    else
      oa = function_onion_address([private_key])
      File.open(hf,'w'){|f| f << oa.to_s }
      oa
    end

    [ onion_address, private_key.to_s ]
  end
end
