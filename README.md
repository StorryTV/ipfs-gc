# ipfs-gc
Automatic IPFS Garbage Collection

Automatic Maintenance Page during garbage collection

# Installation
```
wget https://github.com/StorryTV/ipfs-gc/archive/refs/heads/main.zip -O ipfs-gc.zip
unzip ipfs-gc.zip
rm ipfs-gc.zip
cd ipfs-gc-main
chmod 770 install.sh
sudo ./install.sh
cd ..
rm -rf ipfs-gc-main
```
Or use this one line command below: 
```
wget https://github.com/StorryTV/ipfs-gc/archive/refs/heads/main.zip -O ipfs-gc.zip && unzip ipfs-gc.zip && rm ipfs-gc.zip && cd ipfs-gc-main && chmod 770 install.sh && sudo ./install.sh && cd .. && rm -rf ipfs-gc-main
```
The installation above will ask you how to run automatic garbage collection, follow the steps and don't worry about having to manually garbage collect your IPFS system anymore.
# Run manually after installation is done
```
sudo ipfs-gc -u <USER> -s <MINSTORAGE> -f <FULLPATHTOIPFSBLOCKS>
```
Full Example:
```
sudo ipfs-gc -u bob -s 10485760 -f /home/bob/.ipfs/blocks
```
In the example above, we tell it that the ipfs daemon runs as the following user: bob.

We want to run it only if the total free storage is less than 10GB (Input only in Kilobytes/kb!)

And the path to the ipfs blocks is: /home/bob/.ipfs/blocks (This is to make sure it checks the free storage from the folder as it may differ from other folders on the system if the folder is for example a mount to an external network drive, but in a standard ipfs setup this may not be necessery)

None of the parameters are mandatory, but the keep in mind it then uses default inputs which may not be right for your system.

#
Recommended settings are:
Hourly checks
IPFS_GC_MIN_STORAGE (-s) -> Calculate how much data can be downloaded (in Kilobytes) in an hour by doing the following calculation ( ( ( ( max MB/s Download speed ) * 3600 seconds ) * 1024 ) / 8 ), example: ( ( ( ( 50 ) * 3600 ) * 1024 ) / 8 ) = 23040000

#
Also generates an empty file of 500mb in case your gateway has a very busy day (or DOS attack) and gets a full disk before garbage collection has been able to run or complete. In that case it deletes this file (creating 500mb free space) to be able to function properly as some gateways have had trouble to function again after too many requests filling up the whole disk to the last byte. This prevents this problem as you will always have 500mb left to work with and running IPFS GC to free up space.
