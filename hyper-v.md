# hyper-v

1. enable hyper-v (note if it's enabled, 64-bit vbox machines are likely not possible)
  i. tl;dr -> in Run, search for 'turn windows features on or off'
1. enable connection sharing: https://www.groovypost.com/howto/share-an-ethernet-or-wireless-network-connection-with-hyper-v-in-windows-10/
  i. tl;dr: crate new via Virtual Switch Manager, make sure to select 'Intenal'
  ii. go to your vm settings, select Add Hardware -> (Legacy) Network Adapter & select one you created
  iii. in explorer, open `Control Panel\Network and Internet\Network Connections`, right click on created interface, properties, Sharing tab, and tick 'Allow...'
