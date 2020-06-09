# valor 1 = nombre del namespace y del deployment
# valor 2 = nombre del repo/app
# valor 3 = tamaño del volumen persistente (0 para no necesario)

if [ -z $1 ]; then
	echo 'falta nombre del deployment' && exit 1
else
	kubectl create namespace $1 &>desp.log 
fi

#if [ -z $3 ]; then
#	echo 'falta tamaño volumen persistente' && exit 1
#else
	if [ $3 -gt 0 ]; then
		if [ -f sc.yaml ]; then
			kubectl create -f sc.yaml &>>desp.log 
		else
			echo 'falta fichero sc.yaml' &&	exit 1
		fi

		mkdir -p /var/pods-pv/$1
		chmod 777 /var/pods-pv/$1

		if [ -f pv.yaml ]; then
			kubectl create -f pv.yaml &>>desp.log 
		else
			echo 'falta fichero pv.yaml'
		fi
#		if [ -f pvc.yaml ]; then
#			kubectl create -f pvc.yaml -n $1 &>>desp.log 
#		else
#			echo 'falta fichero pvc.yaml'
#		fi
	fi
#fi

if [ -z $2 ]; then
	echo 'falta directorio' && exit 1
else
# instalacion de chart de repositorio
		echo "confirmacion app:"
		helm search repo $2
		helm install $1 $2 -f values.yaml,pvc.yaml -n $1 &>>desp.log
# instalacion de chart local:
#	if [ -d $2 ]; then
#		helm install  $1 $2 -f $2/values-production.yaml -n $1 &>>desp.log
#	else
#		echo 'error directorio'
#	fi

fi


