az login --use-device-code --tenant 3bb1d348-1195-4267-9e02-ac34257780fc
az account list -o table
az account set -s 4790848c-655f-4a65-9e88-9b20dd2c80d1

UNIQUEID=f2a90d
APPNAME=petclinic
RESOURCE_GROUP=rg-$APPNAME-$UNIQUEID
LOCATION=eastus
MYACR=acr$APPNAME$UNIQUEID
VIRTUAL_NETWORK_NAME=vnet-$APPNAME-$UNIQUEID
AKS_SUBNET_CIDR=10.1.0.0/24
SUBNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP --vnet-name $VIRTUAL_NETWORK_NAME --name aks-subnet --query id -o tsv)
AKSCLUSTER=aks-$APPNAME-$UNIQUEID
MYSQL_SERVER_NAME=mysql-$APPNAME-$UNIQUEID
MYSQL_ADMIN_USERNAME=myadmin
MYSQL_ADMIN_PASSWORD='WLDZ2eNf9aksZLfjY9nGD5EXKV7AQw=='
DATABASE_NAME=petclinic
VERSION=3.0.2
WORKSPACE=la-$APPNAME-$UNIQUEID
WORKSPACEID=$(az monitor log-analytics workspace show -n $WORKSPACE -g $RESOURCE_GROUP --query id -o tsv)
AINAME=ai-$APPNAME-$UNIQUEID
KEYVAULT_NAME=kv-$APPNAME-$UNIQUEID

GIT_PAT="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"


export AKS_OIDC_ISSUER="$(az aks show -n $AKSCLUSTER -g $RESOURCE_GROUP --query "oidcIssuerProfile.issuerUrl" -otsv)"
echo $AKS_OIDC_ISSUER
export USER_ASSIGNED_IDENTITY_NAME=uid-$APPNAME-$UNIQUEID
export USER_ASSIGNED_CLIENT_ID="$(az identity show --resource-group "${RESOURCE_GROUP}" --name "${USER_ASSIGNED_IDENTITY_NAME}" --query 'clientId' -otsv)"
echo $USER_ASSIGNED_CLIENT_ID

export SERVICE_ACCOUNT_NAME="workload-identity-sa"
export DB_ADMIN_USER_ASSIGNED_IDENTITY_NAME=uid-dbadmin-$APPNAME-$UNIQUEID

export DB_ADMIN_USER_ASSIGNED_IDENTITY_NAME=uid-dbadmin-$APPNAME-$UNIQUEID

export CURRENT_USER=$(az account show --query user.name --output tsv)
echo $CURRENT_USER
export CURRENT_USER_OBJECTID=$(az ad signed-in-user show --query id --output tsv)
echo $CURRENT_USER_OBJECTID
export IDENTITY_LOGIN_NAME="mysql_conn"
export SERVICEBUS_NAMESPACE=sb-$APPNAME-$UNIQUEID

export SERVICEBUS_CONNECTIONSTRING="Endpoint=sb://sb-petclinic-f2a90d.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=9Brk8f4jITbJB23I4oueljiToGlhTtAXv+ASbHUCfaw="

EVENTHUBS_NAMESPACE=evhns-$APPNAME-$UNIQUEID
EVENTHUB_ID=$(az eventhubs namespace show --name $EVENTHUBS_NAMESPACE --resource-group $RESOURCE_GROUP --query id -o tsv)
echo $EVENTHUB_ID

echo $USER_ASSIGNED_CLIENT_ID

STORAGE_ACCOUNT_NAME=stg$APPNAME$UNIQUEID
echo $STORAGE_ACCOUNT_NAME
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --sku "Standard_LRS" 
az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --query id -o tsv
STORAGE_ACCOUNT_ID=$(az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --query id -o tsv)
echo $STORAGE_ACCOUNT_ID

STORAGE_CONTAINER=eventhubs-binder
az storage container create --name $STORAGE_CONTAINER --account-name $STORAGE_ACCOUNT_NAME --public-access container --auth-mode login

AKS_MC_RG=$(az aks show -n $AKSCLUSTER -g $RESOURCE_GROUP | jq -r '.nodeResourceGroup')

echo $AKS_MC_RG

AKS_MC_LB_INTERNAL=kubernetes-internal

az network lb frontend-ip list -g $AKS_MC_RG --lb-name=$AKS_MC_LB_INTERNAL -o table

AKS_MC_LB_INTERNAL_FE_IP1=$(az network lb frontend-ip list -g $AKS_MC_RG --lb-name=$AKS_MC_LB_INTERNAL | jq -r '.[0].privateIPAddress')
AKS_MC_LB_INTERNAL_FE_IP2=$(az network lb frontend-ip list -g $AKS_MC_RG --lb-name=$AKS_MC_LB_INTERNAL | jq -r '.[1].privateIPAddress')

echo $AKS_MC_LB_INTERNAL_FE_IP1
echo $AKS_MC_LB_INTERNAL_FE_IP2