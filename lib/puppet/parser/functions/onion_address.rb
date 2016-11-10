require 'base32'
module Puppet::Parser::Functions
  newfunction(:onion_address, :type => :rvalue, :doc => <<-EOS
Generates an onion address from a 1024-bit RSA private key.

Example:

  onion_address("-----BEGIN RSA PRIVATE KEY-----
MII....
-----END RSA PRIVATE KEY-----")

Returns the onionadress for that key, *without* the .onion suffix.
  EOS
  ) do |args|
    key = args.shift
    raise(Puppet::ParseError, "onion_address(): requires 1 argument") unless key && args.empty?
    private_key = key.is_a?(OpenSSL::PKey::RSA) ? key : OpenSSL::PKey::RSA.new(key)

    # the onion address are a base32 encoded string of the first half of the sha1 over the
    # der format of the public key
    # https://trac.torproject.org/projects/tor/wiki/doc/HiddenServiceNames#Howare.onionnamescreated
    # We can skip the first 22 bits of the der format as they are ignored by tor
    # https://timtaubert.de/blog/2014/11/using-the-webcrypto-api-to-generate-onion-names-for-tor-hidden-services/
    # https://gitweb.torproject.org/torspec.git/tree/rend-spec.txt#n525
    # Except for Ruby 1.8.7 where the first 22 are not present at all
    start = RUBY_VERSION.to_f < 1.9 ? 0 : 22
    public_key_der = private_key.public_key.to_der
    Base32.encode(Digest::SHA1.digest(public_key_der[start..-1]))[0..15].downcase
  end
end
