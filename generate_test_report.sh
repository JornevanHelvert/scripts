#!/bin/bash
while getopts "e:c:" opt
do
    case $opt in
        e)  environment=$OPTARG;;
        c)  collection=$OPTARG;;
        \?) echo "Invalid option: -$OPTARG"
            exit 1;;
    esac
done
if [ -z "$environment" ] || [ -z "$collection" ]; then
    echo "-e (environment) and -c (collection) options are required"
    exit 1;
else
	echo installing nvm
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
	echo "Verifying nvm install"
	if [ $? -eq 0 ]; then 
		echo "nvm installed successfully, installing node and npm"
		nvm install node
		nvm use node
		echo "node and npm installed, installing newman"
		npm i -g newman
		npm i -g newman-reporter-html
		echo "newman installed, running tests (this can take a while and no output will be shown, do not stop the script!)"
		newman run -e $environment $collection --ignore-redirects -r html
		echo "Test report generated"
		exit 0;
	else
		echo "nvm install failed"
		exit 1;
	fi
fi