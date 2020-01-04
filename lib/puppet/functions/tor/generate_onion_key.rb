# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----

# ---- original file header ----
#
# @summary
#   Generates or loads a rsa private key for an onion service, returns they onion
#onion address and the private key content.
#
#Requires a location to load and store the private key, as well an identifier, which will be used as a filename in the location.
#
#Example:
#
#    res = generate_onion_key('/tmp','my_secret_key')
#    notice "Onion Address: ${res[0]"
#    notice "Priavte Key: ${res[1]"
#
#
#It will also store the onion address under /tmp/my_secret_key.hostname.
#If /tmp/my_secret_key.key exists, but not the hostname file. Then the function will be loaded and the onion address will be generated from it.
#
#
#
Puppet::Functions.create_function(:'tor::generate_onion_key') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    
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