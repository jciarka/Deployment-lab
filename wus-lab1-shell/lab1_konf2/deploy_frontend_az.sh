#!/bin/bash
# __________ config ___________
nginx=$(cat config | grep nginx)
nginx_a=($nginx)

front=$(cat config | grep frontend)
front_a=($front)

# __________ nginx _____________
# create folders
echo "creating resources folder..."
az vm run-command invoke -g ${nginx_a[5]} -n ${nginx_a[6]} --command-id RunShellScript \
    --scripts "mkdir /home/${nginx_a[7]}/petclinic ; mkdir /home/${nginx_a[7]}/petclinic/nginx ; mkdir /home/${nginx_a[7]}/petclinic/frontend ; sudo chown -R ${nginx_a[7]} /home/${nginx_a[7]}/petclinic/nginx ; sudo chown -R ${nginx_a[7]} /home/${nginx_a[7]}/petclinic/frontend ; sudo rm -r /home/${nginx_a[7]}/petclinic/frontend/**"

echo "installing and nginx..."
az vm run-command invoke -g ${nginx_a[5]} -n ${nginx_a[6]} --command-id RunShellScript \
    --scripts "sudo apt-get update && sudo apt-get install -y nginx && sudo systemctl stop nginx && sudo rm /etc/nginx/sites-enabled/default"

echo "preparing petclinic.conf configuration for loadbalancer ..."
server_config_base=$(cat resources/petclinic.conf)
nginx_config_servers=""
IFS=$'\n'
for back in $(cat config | grep backend)
do
	IFS=$' '
	back_a=($back)
	nginx_config_servers+="    server ${back_a[4]}:${back_a[2]};\n"
done
server_config="${server_config_base/TO_DO:/"$nginx_config_servers"}"    

echo -e "config file ready: \n"
echo -e "$server_config\n"

echo "installing config file in /etc/nginx/sites-enabled/petclinic.conf ... "  	
echo -e "$server_config" > petclinic-ready.conf
scp petclinic-ready.conf ${nginx_a[7]}@${nginx_a[1]}:/home/${nginx_a[7]}/petclinic/nginx/petclinic.conf
rm petclinic-ready.conf
az vm run-command invoke -g ${nginx_a[5]} -n ${nginx_a[6]} --command-id RunShellScript \
	--scripts "sudo cp /home/${nginx_a[7]}/petclinic/nginx/petclinic.conf /etc/nginx/sites-enabled/petclinic.conf ; sudo systemctl start nginx"

# __________ frontend _____________
echo -e "\n\n____________ Processing ${front_a[0]} _____________"
environment_ts="export const environment = {\n
  production: true,\n
  REST_API_URL: 'http://${nginx_a[1]}:${nginx_a[2]}/petclinic/api/'\n
};"
environment_ts_loc="${front_a[3]}/src/environments/environment.prod.ts"

echo "generating frontend environment.ts in '$environment_ts_loc'"  
echo -e $environment_ts > $environment_ts_loc

pushd ${front_a[3]}

	echo "building frontend..."  
	ng build --prod
	tar -czvf dist.tar.gz dist/*

	echo "instaling new angular dist..."
	scp dist.tar.gz ${nginx_a[7]}@${nginx_a[1]}:/home/${nginx_a[7]}/petclinic/frontend
	rm dist.tar.gz
	az vm run-command invoke -g ${nginx_a[5]} -n ${nginx_a[6]} --command-id RunShellScript \
		--scripts "sudo rm -r /var/www/html/** ; sudo tar -xzvf /home/${nginx_a[7]}/petclinic/frontend/dist.tar.gz --directory /var/www/html/ ;  sudo mv  /var/www/html/dist/** /var/www/html/ ; sudo rm -r /var/www/html/dist; sudo systemctl restart nginx"	
popd
