Facter.add(:tor_hidden_services) do
  confine :kernel => "Linux"
  setcode do
    config_file = '/etc/tor/torrc'
    if File.exists?(config_file)
      dirs = File.read(config_file).split("\n").select{|l|
        l =~ /^HiddenServiceDir/
      }.collect{|l| l.sub(/^HiddenServiceDir /,'') }
      dirs.inject({}) { |res,d|
        if File.exists?(h=File.join(d,'hostname'))
          res[File.basename(d)] = File.read(h).chomp
        end
        res
      }
    else
      {}
    end
  end
end
