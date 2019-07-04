# hyper-v

1. enable hyper-v (note if it's enabled, 64-bit vbox machines are likely not possible)
    1. tl;dr -> in Run, search for 'turn windows features on or off'
1. enable connection sharing: https://www.groovypost.com/howto/share-an-ethernet-or-wireless-network-connection-with-hyper-v-in-windows-10/
    1. tl;dr of above link: crate new via `Virtual Switch Manager`, make sure to select 'Intenal'
    1. go to your vm settings, select Add Hardware -> (Legacy) Network Adapter & select one you created
    1. in explorer, open `Control Panel\Network and Internet\Network Connections`, right click on created interface, properties, Sharing tab, and tick `Allow...`

# vbox

Only to be used _instead of_ hyper-v - 64b vbox & hyper-v are mutually exclusive.

1. 

## misc

Regardless whether vbox or hyper-v, if you're still in early stages of installation (or are recovering from snapshot)
and network's not working:

1. check you interface: `cat /etc/network/interfaces`, likely it'll be enp0s3;
1. bump it: `/sbin/ifdown enp0s3` & `/sbin/ifup enp0s3`
