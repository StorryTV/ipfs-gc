# ipfs-gc
Standalone IPFS Garbage Collection (automatic)
#
This can be run from the command line by just running 'ipfs-gc'.
#
# Installation
```
wget https://github.com/StorryTV/ipfs-gc/archive/refs/heads/main.zip -O ipfs-gc.zip
unzip ipfs-gc.zip
rm ipfs-gc.zip
cd ipfs-gc-main
chmod 770 install.sh
sudo ./install.sh
```
# Run manually after installation is done
```
sudo ipfs-gc -u <USER> -s <MINSTORAGE> -f <FULLPATHTOIPFSBLOCKS>
```
Full Example:
```
sudo ipfs-gc -u bob -s 10485760 -f /home/bob/.ipfs/blocks
```
In the example above, we tell it that the ipfs daemon runs as the following user: bob
We want to run it only if the total free storage is less than 10GB (Only in bytes!)
And the path to the ipfs blocks is: /home/bob/.ipfs/blocks (This is to make sure it checks the free storage from the folder as it may differ from other folders on the system if the folder is for example a mount to an external network drive, but in a standard ipfs setup this may not be necessery)

None of the parameters are mandatory, but the keep in mind it then uses default inputs which may not be right for your system.
