# Swap should generally be double your memory allocation.
swap_size = 2048

# It's probably not related to swap, but it is a really early set up thing.
# See https://gist.github.com/rmarchei/4f63b6682766721e178eec9722dc7368
execute 'fix-ubuntu-disk' do
  command 'udevadm trigger --action=add --subsystem-match=scsi'
  action :run
end

# echo 180 > /sys/block/sda/device/timeout

script 'create swapfile' do
  interpreter 'bash'
  not_if { File.exists?('/var/swapfile') }
  code <<-eof
    sudo fallocate -l #{swap_size}M /var/swapfile &&
    chmod 600 /var/swapfile &&
    mkswap /var/swapfile
  eof
end

mount '/dev/null' do  # swap file entry for fstab
  action :enable  # cannot mount; only add to fstab
  device '/var/swapfile'
  fstype 'swap'
end

script 'activate swap' do
  interpreter 'bash'
  code 'swapon -a'
end
