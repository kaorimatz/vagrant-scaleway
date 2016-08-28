# Vagrant Scaleway Provider

[![Gem](https://img.shields.io/gem/v/vagrant-scaleway.svg?style=flat-square)](https://rubygems.org/gems/vagrant-scaleway)
[![Gemnasium](https://img.shields.io/gemnasium/kaorimatz/vagrant-scaleway.svg?style=flat-square)](https://gemnasium.com/kaorimatz/vagrant-scaleway)

This is a [Vagrant](http://www.vagrantup.com/) plugin that adds a
[Scaleway](https://www.scaleway.com/) provider to Vagrant, allowing Vagrant to
control and provision machines in Scaleway.

## Features

- Boot Scaleway servers.
- SSH into the servers.
- Provision the servers with any built-in Vagrant provisioner.
- Minimal synced folder support via rsync.

## Prerequisites

Prior to using this plugin, you will first need to create an API token and
identify your organization ID. Please see the following help pages for
instructions.

- [How to generate an API token](https://www.scaleway.com/docs/generate-an-api-token/)
- [How to retrieve my organization ID through the API](https://www.scaleway.com/docs/retrieve-my-organization-id-throught-the-api/)

## Installation

Install using standard Vagrant plugin installation methods.

    $ vagrant plugin install vagrant-scaleway

## Usage

First, make a Vagrantfile that looks like the following:

```ruby
Vagrant.configure('2') do |config|
  config.vm.provider :scaleway do |scaleway, override|
    scaleway.organization = 'YOUR_ORGANIZATION_UUID'
    scaleway.token = 'YOUR_TOKEN'

    override.ssh.private_key_path = '~/.ssh/id_rsa'
  end
end
```

And then run `vagrant up` and specify the `scaleway` provider:

    $ vagrant up --provider=scaleway

## Configurations

Please see the [RubyDoc](http://www.rubydoc.info/gems/vagrant-scaleway/VagrantPlugins/Scaleway/Config)
for the list of provider-specific configuration options.

## Development

To work on the `vagrant-scaleway` plugin, clone this repository out, and use
[Bundler](http://gembundler.com) to get the dependencies:

    $ bundle

If those pass, you're ready to start developing the plugin. You can test
the plugin without installing it into your Vagrant environment by just
creating a `Vagrantfile` in the top level of this directory (it is gitignored)
that uses it, and uses bundler to execute Vagrant:

    $ bundle exec vagrant up --provider=scaleway

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kaorimatz/vagrant-scaleway.

## License

The plugin is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
