# you must be logged on to your Azure subscription with az login
az group create --name WPRG --location "South Central US"
az appservice plan create --name WPServicePlan --resource-group WPRG --sku B1 --is-linux
az webapp create --resource-group WPRG --plan WPServicePlan --name davidswp --multicontainer-config-type compose --multicontainer-config-file compose-wordpress-step1.yml
az mysql server create --resource-group WPRG --name davidswpmysqldb  --location "South Central US" --admin-user adminuser --admin-password Dav1d55up3rStr0ngPaSw0rd! --sku-name B_Gen5_2 --version 5.7
az mysql server firewall-rule create --name allAzureIPs --server davidswpmysqldb --resource-group WPRG --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0
az mysql db create --resource-group WPRG --server-name davidswpmysqldb --name wordpress
az webapp config appsettings set --resource-group WPRG --name davidswp --settings WORDPRESS_DB_HOST="davidswpmysqldb.mysql.database.azure.com" WORDPRESS_DB_USER="adminuser@davidswpmysqldb" WORDPRESS_DB_PASSWORD="Dav1d55up3rStr0ngPaSw0rd!" WORDPRESS_DB_NAME="wordpress" MYSQL_SSL_CA="BaltimoreCyberTrustroot.crt.pem"
az webapp config container set --resource-group WPRG --name davidswp --multicontainer-config-type compose --multicontainer-config-file compose-wordpress-step2.yml
az webapp config appsettings set --resource-group WPRG --name davidswp --settings WEBSITES_ENABLE_APP_SERVICE_STORAGE=TRUE
az webapp config container set --resource-group WPRG --name davidswp --multicontainer-config-type compose --multicontainer-config-file compose-wordpress-step3.yml
az webapp config appsettings set --resource-group WPRG --name davidswp --settings WP_REDIS_HOST="redis"
az webapp config container set --resource-group WPRG --name davidswp --multicontainer-config-type compose --multicontainer-config-file compose-wordpress-step4.yml
