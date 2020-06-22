#======== ENV VARIABLES ===========================================
export ENTITLED_REGISTRY_USER=cp
export ENTITLED_REGISTRY=cp.icr.io
export ENTITLED_REGISTRY_KEY=eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE1OTEyNjk2NDksImp0aSI6IjVmYzEyMjY2ZjAyODQ3ZWRiNTNiZWQ0ZDZiYTk2ODFlIn0.M8mOeH3O-RcySFwNNFvb8vJZj5FO2mAI8srob40FuyE  #use your key
#==================================================================


docker login -u $ENTITLED_REGISTRY_USER -p $ENTITLED_REGISTRY_KEY $ENTITLED_REGISTRY
docker pull "cp.icr.io/cp/icpa/icpa-installer:4.1.1"
echo  "Image is present locally now."
echo  "-----------------------------"
mkdir data
docker run -v $PWD/data:/data:z -u 0 \
           -e LICENSE=accept \
           "cp.icr.io/cp/icpa/icpa-installer:4.1.1" cp -r "data/*" /data
echo  "data directory is populated  "
echo  "-----------------------------"

sed -i 's/ReadWriteMany/ReadWriteOnce/g' /opt/data/transadv.yaml

echo "string replaced "

docker run -v ~/.kube:/root/.kube:z -u 0 -t \
           -v $PWD/data:/installer/data:z \
           -e LICENSE=accept \
           -e ENTITLED_REGISTRY -e ENTITLED_REGISTRY_USER -e ENTITLED_REGISTRY_KEY \
           "$ENTITLED_REGISTRY/cp/icpa/icpa-installer:4.1.1" check
echo  "Installation check has completed."
echo  "---------------------------------"
docker run -v ~/.kube:/root/.kube:z -u 0 -t \
           -v $PWD/data:/installer/data:z \
           -e LICENSE=accept \
           -e ENTITLED_REGISTRY -e ENTITLED_REGISTRY_USER -e ENTITLED_REGISTRY_KEY \
           "$ENTITLED_REGISTRY/cp/icpa/icpa-installer:4.1.1" install
echo  "Installation of CP4A is complete."
echo  "---------------------------------"
