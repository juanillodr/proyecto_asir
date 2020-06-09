#instalacion por cli
helm install --name local-chartmuseum -f chartmuseum.yaml stable/chartmuseum 

kubectl create namespace chartmuseum
kubectl create serviceaccount chartmuseum-operator
kubectl create clusterrolebinding chartmuseum-operator --clusterrole=cluster-admin --serviceaccount=default:chartmuseum-operator

valor=$(kubectl get serviceaccount chartmuseum-operator -o jsonpath='{.secrets[].name}')
kubectl get secret $valor -o go-template='{{.data.token | base64decode}}' >kubeapps.token

#kubectl delete clusterrolebinding chartmuseum-operator --clusterrole=cluster-admin --serviceaccount=default:chartmuseum-operator

