#!/bin/bash

# __________ config ___________
back_all_master=$(cat config | grep backendmaster)
back_all_slave=$(cat config | grep backendslave)


database=$(cat config | grep database)
database_a=($database)

# __________ backend master___________
echo "__________ Processing backend ___________ "
echo "Preparing application properties ..."
IFS=$'\n'
back_list=($back_all_master)
back_first="${back_list[0]}"
IFS=' '
back_first_a=($back_first)

sed -i "s/hsqldb/mysql/" ${back_first_a[3]}/src/main/resources/application.properties
cp resources/application-mysql.properties ${back_first_a[3]}/src/main/resources/application-mysql.properties

echo "Building backend"
pushd ${back_first_a[3]}
	./mvnw package
popd
i=1
cat config | grep backendmaster | while read -r back ; do
    pushd ${back_first_a[3]}
    back_a=($back)
    echo -e "\n\n____________ Deploying ${back_a[0]} $i ____________"

	echo "installing jre..."
	az vm run-command invoke -g ${back_a[5]} -n ${back_a[6]} --command-id RunShellScript \
		--scripts "sudo apt update ; sudo apt install -y default-jre"

	echo "creating resources folder..."
	az vm run-command invoke -g ${back_a[5]} -n ${back_a[6]} --command-id RunShellScript \
		--scripts "mkdir /home/${back_a[7]}/petclinic ; mkdir /home/${back_a[7]}/petclinic/backend$i ; sudo chown -R ${back_a[7]} /home/${back_a[7]}/petclinic/backend$i ; sudo rm -r /home/${back_a[7]}/petclinic/backend$i/**"
	
	scp target/*.jar ${back_a[7]}@${back_a[1]}:/home/${back_a[7]}/petclinic/backend$i

    echo "switching on backend ... "  
	az vm run-command invoke -g ${back_a[5]} -n ${back_a[6]} --command-id RunShellScript \
		--scripts "sudo kill $( sudo lsof -i:${back_a[2]} -t ) ; export MYSQL_CONNECTION_STR=jdbc:mysql://${database_a[4]}:3306/petclinic ; export MYSQL_USERNAME=petclinic ; export MYSQL_PASSWORD=petclinic ; java -Dserver.port=${back_a[2]} -jar /home/${back_a[7]}/petclinic/backend$i/*.jar &" 
	
    i=$[$i+1]
    popd
done

# __________ backend slave___________
echo "__________ Processing backend ___________ "
echo "Preparing application properties ..."
IFS=$'\n'
back_list=($back_all_slave)
back_first="${back_list[0]}"
IFS=' '
back_first_a=($back_first)

sed -i "s/hsqldb/mysql/" ${back_first_a[3]}/src/main/resources/application.properties
cp resources/application-mysql.properties ${back_first_a[3]}/src/main/resources/application-mysql.properties

echo "Building backend"
pushd ${back_first_a[3]}
	./mvnw package
popd
i=1
cat config | grep backendslave | while read -r back ; do
    pushd ${back_first_a[3]}
    back_a=($back)
    echo -e "\n\n____________ Deploying ${back_a[0]} $i ____________"

	echo "installing jre..."
	az vm run-command invoke -g ${back_a[5]} -n ${back_a[6]} --command-id RunShellScript \
		--scripts "sudo apt update ; sudo apt install -y default-jre"

	echo "creating resources folder..."
	az vm run-command invoke -g ${back_a[5]} -n ${back_a[6]} --command-id RunShellScript \
		--scripts "mkdir /home/${back_a[7]}/petclinic ; mkdir /home/${back_a[7]}/petclinic/backend$i ; sudo chown -R ${back_a[7]} /home/${back_a[7]}/petclinic/backend$i ; sudo rm -r /home/${back_a[7]}/petclinic/backend$i/**"
	
	scp target/*.jar ${back_a[7]}@${back_a[1]}:/home/${back_a[7]}/petclinic/backend$i

    echo "switching on backend ... "  
	az vm run-command invoke -g ${back_a[5]} -n ${back_a[6]} --command-id RunShellScript \
		--scripts "sudo kill $( sudo lsof -i:${back_a[2]} -t ) ; export MYSQL_CONNECTION_STR=jdbc:mysql://${database_a[4]}:3307/petclinic ; export MYSQL_USERNAME=petclinic ; export MYSQL_PASSWORD=petclinic ; java -Dserver.port=${back_a[2]} -jar /home/${back_a[7]}/petclinic/backend$i/*.jar &" 
	
    i=$[$i+1]
    popd
done


exit 0