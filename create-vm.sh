
#!/bin/bash

loop=1
while [ $loop -eq 1 ]; do
echo ========================================
echo "VM Creation Script"
echo ========================================
echo "Please Create a Name:"
read vm_name
echo "Please Select the Network: ( ip a )"
read vm_device
echo "Please Add an IP: (IP/NN)"
read vm_ip
read -r -p "Configure a Gateway? [y/N]" answ_gw
case $answ_gw in
    [yY][eE][sS]|[yY])
        loop=0
	read -r -p "GW Name:" vm_gw
	gw=true
        ;;
    *)
        loop=0
	;;
esac
echo ========================================
echo "Please ensure the following is correct:"
echo "VM Name:	$vm_name"
echo "VM Device:	$vm_device"
echo "VM IP/Netmask:	$vm_ip"
echo "VM Gatgeway:	$vm_gw"
echo ========================================
read -r -p "Is this correct? [y/N]" answ_verify
echo ========================================
case $answ_verify in
    [yY][eE][sS]|[yY])
 	loop=0
	echo "Creating VM..."
	lxc-create -n $vm_name -t debian
	sed -i 's/lxc.network.type = empty//' /var/lib/lxc/$vm_name/config
        echo "lxc.network.type = veth" >> /var/lib/lxc/$vm_name/config
	echo "lxc.network.flags = up" >> /var/lib/lxc/$vm_name/config
	echo "lxc.network.link = $vm_device" >> /var/lib/lxc/$vm_name/config
	echo "lxc.network.ipv4 = $vm_ip" >> /var/lib/lxc/$vm_name/config
	if [ "$gw" = "true" ] ; then
	echo "lxc.network.ipv4.gateway = $vm_gw" >> /var/lib/lxc/$vm_name/config
	fi
	echo "VM Sucessfully Created"
        ;;
    *)
	echo ===STARTING OVER===
	loop=1
        ;;
esac
done
