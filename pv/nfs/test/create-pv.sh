# usar privilegios root
# $1= nombre del directorio nfs a crear
#/bin/bash!
red_local='192.168.18.0/24'
red_docker='172.17.0.0/16'
red_calico='10.217.0.0/16'
usuario='mik'
directorio='/var/pods-pv/nfs/'
log='./create-pv.log'
permisos='rw,sync,no_root_squash,no_subtree_check,no_all_squash'

rm $log
if [ -d $directorio$1 ];
then echo "directorio ya existe"
else
	echo "creando directorio \n"
	mkdir -p $directorio$1
	chown $usuario:$usuario $directorio$1
	chmod 775 $directorio$1

	echo "instalando nfs \n"
	apt-get install nfs-kernel-server nfs-common -y >> $log
	echo "$directorio$1 $red_local($permisos)" >> /etc/exports
	echo "$directorio$1 $red_docker($permisos)" >> /etc/exports
	echo "$directorio$1 $red_calico($permisos)" >> /etc/exports
	exportfs -a >> $log

	echo "iniciando nfs \n"
	systemctl restart nfs-kernel-server.service >> $log
fi
# excepciones firewall
# ufw allow from $red_local to any ports nfs
# ufw allow from $red_docker to any ports nfs
# ufw allow from $red_calico to any ports nfs

showmount localhost --exports


