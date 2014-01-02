Facter.add("redis_installed") do
  redis_binary = "/usr/local/bin/redis-server"

  setcode do
    File.exists? redis_binary
  end
end
