# tor

#### Table of Contents

1. [Description](#description)
2. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Getting started](#getting-started)
3. [Functions](#reference)
    * [onion_address](#onion_address)
    * [generate_onion_key](#generate_onion_key)
4. [Facts](#reference)
    * [tor_hidden_services](#tor_hidden_services)
5. [Reference](#reference)
6. [Development](#development)

## Description

This module manages tor and is mainly geared towards people running it on
servers. With this module, you should be able to manage most, if not all of
the functionalities provided by tor, such as:

* relays
* bridges and exit nodes
* onion services
* exit policies
* transport plugins

## Setup

### Setup Requirements

This module needs:

 * the [concat module](https://github.com/puppetlabs/puppetlabs-concat.git)
 * the [stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib.git)
 * the [apt module](https://github.com/puppetlabs/puppetlabs-apt.git)

Explicit dependencies can be found in the project's metadata.json file.

### Getting started

`class { 'tor': }` will install tor with a default configuration. Chances are
you will want to configure Tor in a certain way. This is accomplished declaring
one or more of the `tor::daemon` defined types.

For example, this will configure a tor bridge relay running on port 8080:

``` puppet
  tor::daemon::relay {
    'MyNickname':
      bridge_relay     => true,
      port             => 8080,
      address          => '1.1.1.1',
      bandwidth_rate   => 12500,
      bandwidth_burst  => 12500,
      contact_info     => 'Foo Bar <foo@bar.com>',
  }
```

# Functions

This module comes with 3 functions specific to tor support. They require the
base32, ed25519 and sha3 gem to be installed on the master or wherever they are
executed. For JRuby based installations such as puppetserver environments you
can use the sha3-pure-ruby instead of the C based library.

## onionv3_key

This functions generates an onion v3 key pair if not already existing. As
arguments, you need to pass a base directory and an indentifier (name) of the key.
The key pair will be looked up in a directory under <base_dir>/<name>.

As a result you will get a hash containing they secret key (hs_ed25519_secret_key),
the public key (hs_ed25519_public_key) and the onion hostname (hostname). The
latter will be without the `.onion` suffix.

If a key has already been created and exists under that directory, the content
of these files will be returned.

## onion_address

This function takes a 1024bit RSA private key as an argument and returns the
onion v2 address for an onion service for that key.

## generate_onion_key

This function takes a path (on the puppet master!) and an identifier for a key
and returns an array containing the matching onion v2 address and the private key.
The private key either exists under the supplied `path/key_identifier` or is
being generated on the fly and stored under that path for the next execution.

# Facts

## tor_hidden_services

This fact gives you a list of the hidden services you are running.

# Reference

The full reference documentation for this module may be found at on
[GitLab Pages][pages].

Alternatively, you may build yourself the documentation using the
`puppet strings generate` command. See the documentation for
[Puppet Strings][strings] for more information.

[pages]: https://shared-puppet-modules-group.gitlab.io/tor
[strings]: https://puppet.com/blog/using-puppet-strings-generate-great-documentation-puppet-modules

## Development

This module's development is tracked on GitLab. Please submit issues and merge
requests on the [shared-puppet-modules-group/tor][smash] project page.

[smash]: https://gitlab.com/shared-puppet-modules-group/tor/
