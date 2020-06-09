#ayuda:
# $1 = install/uninstall/upgrade 
# $2 = nombre deployment
# $3 = namespace
# $4 = repo/app o directorio del char innecesario para uninstall
# $5 = set opcionales de helm install
if [ -z $1 ]; then
        echo 'falta install/uninstall/upgrade' && exit 1
fi

if [ -z $2 ]; then
        echo 'falta nombre deployment' && exit 1
fi

if [ -z  $3 ]; then
        echo 'falta namespace' &&  exit 1
else
	if [ $1 = 'uninstall' ]; then
#		kubectl delete ingress $2 -n $3 &>desp.log
		helm uninstall $2 -n $3 &>>desp.log
		kubectl delete events --all -n $3 &>>desp.log
		if [ $2 = $3 ]; then
			echo 'deploy=namespace'
	        	kubectl delete namespace $3 &>>desp.log
        	fi
		cat desp.log && exit 1
	fi
fi

if [ -z  $4 ]; then
        echo 'falta repo/app o directorio del chart' && exit 1
else

	if [ $1 = 'upgrade' ]; then

		kubectl delete events --all -n $3 &>>desp.log
		helm upgrade $2 $4 -n $3 -f $4/values.yaml &>>desp.log
	        cat desp.log
		sleep 5
		watch kubectl get all -n $3 -o wide #pantalla en espera de creacion de recursos
		kubectl get events -n $3
	fi

	if [ $1 = 'install' ]; then

		kubectl create namespace $3 &>desp.log
		kubectl create -f ~/proyecto/cert-manager/staging-issuer.yaml -n $3 &>>desp.log
 		kubectl create -f ~/proyecto/cert-manager/production-issuer.yaml -n $3 >>desp.log
	        helm install  $2 $4 -n $3 -f $4/values.yaml $5 &>>desp.log
		sleep 10
		kubectl get pv,pvc -n $3    #tiempo volumen creados y enlazados
		cat desp.log
		sleep 50
		watch kubectl get all -n $3 -o wide #pantalla en espera de creacion de recursos
		kubectl events -n $3

	fi

fi



