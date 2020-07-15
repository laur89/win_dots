# hyper-v

1. enable hyper-v (note if it's enabled, 64-bit vbox machines are likely not possible)
    1. tl;dr -> in Run, search for 'turn windows features on or off'
1. enable connection sharing: https://www.groovypost.com/howto/share-an-ethernet-or-wireless-network-connection-with-hyper-v-in-windows-10/
    1. tl;dr of above link: crate new via `Virtual Switch Manager`, make sure to select 'Intenal'
    1. go to your vm settings, select Add Hardware -> (Legacy) Network Adapter & select one you created
    1. in explorer, open `Control Panel\Network and Internet\Network Connections`, right click on created interface, properties, Sharing tab, and tick `Allow...`

# vbox

Only to be used _instead of_ hyper-v - 64b vbox & hyper-v are mutually exclusive.
For work devbox, you'll want minimum of `80g` drive, 90g would be even better.
Note for vbox we don't create separate partition for `/data`. Maybe would make
sense to start doing that, and create separate .vdi for it?

1. 

## misc

### Networking not working

Regardless whether vbox or hyper-v, if you're still in _early stages of installation_ (or are recovering from snapshot)
and network's not working:

1. check you interface: `cat /etc/network/interfaces`, likely it'll be enp0s3;
1. bump it: `/sbin/ifdown enp0s3` & `/sbin/ifup enp0s3`

### vbox: can't enable nested virtualisation 

if `System->Processor->Enable Nested VT-x/AMD-V` tickbox is grayed out, the need to start vbox with a flag as per [this comment](https://stackoverflow.com/a/57229749/1803648):
```
   In Windows, go to VirtualBox installation folders -> type cmd on the bar (it will pop up cmd in that folder);
   -> type:
       VBoxManage modifyvm YourVirtualBoxName --nested-hw-virt on
   -> enter.

   Now it should been ticked.
```
