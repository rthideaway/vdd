
berks-update:
	berks update
	rm -rf ./berks-cookbooks
	berks vendor

clean:
	vagrant destroy -f

package-box: clean
	vagrant destroy -f
	vagrant box update
	vagrant up
	vagrant package

# I'm too scared of running this one accidentally.
# annihilate: clean
# vbox manage detach that persistant-storage.vdi. Not sure exact spec though
# 	rm persistant-storage.vdi
