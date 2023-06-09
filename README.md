# Infrastructure as Code (IaC)
- [Infrastructure as Code (IaC)](#infrastructure-as-code-iac)
  - [What is IaC?](#what-is-iac)
    - [Benefits:](#benefits)
    - [Tools used](#tools-used)
  - [IaC with Ansible](#iac-with-ansible)
  - [Configuration Management with Ansible](#configuration-management-with-ansible)
    - [Ansible Set up and SSH connections](#ansible-set-up-and-ssh-connections)
    - [Adhoc Commands with Ansible](#adhoc-commands-with-ansible)
    - [Ansible Playbooks - YAML](#ansible-playbooks---yaml)
      - [Ansible Nginx Playbooks](#ansible-nginx-playbooks)
      - [Ansible Copy 'app' Playbook](#ansible-copy-app-playbook)
      - [Ansible NodeJS Playbook](#ansible-nodejs-playbook)
      - [Ansible Set Up MongoDB Playbook](#ansible-set-up-mongodb-playbook)
      - [Ansible Start App Playbook](#ansible-start-app-playbook)
  - [IaC with Terraform](#iac-with-terraform)
    - [Install Terraform on Windows](#install-terraform-on-windows)
    - [Setup Terraform to interact with AWS and launch an EC2](#setup-terraform-to-interact-with-aws-and-launch-an-ec2)
    - [Terraform create two-tier VPC and EC2 instances](#terraform-create-two-tier-vpc-and-ec2-instances)

## <a id="what-is-iac">What is IaC?</a>

Infrastructure as Code (IaC) is a software engineering approach and practice that involves **managing and provisioning computing infrastructure resources automatically** using machine-readable configuration files or scripts. Instead of manually setting up and configuring servers, networks, and other infrastructure components, IaC allows developers and system administrators to define and manage their infrastructure using code.

**Infrastructure code = code that we write for machines to understand.**

![End-to-end IaC](/images/iac-overall.png)

With Infrastructure as Code, the entire infrastructure stack, including servers, networks, storage, and other resources, is described and managed through code<!-- , typically in a declarative or imperative programming language -->. The code defines the desired state of the infrastructure, specifying how it should be provisioned, configured, and deployed. 

### <a id="benefits">Benefits:</a>

By treating infrastructure as code, organizations can achieve **greater efficiency**, **consistency**, **scalability**, and **automation**, meaning we eliminate manual processes, in managing their computing infrastructure, making it **easier to deploy and manage applications in a reliable and reproducible manner**.

- Version control: Infrastructure code can be stored in version control systems, allowing teams to track changes, collaborate, and roll back to previous versions if needed.

- Reproducibility: Infrastructure can be reliably reproduced across different environments, ensuring consistency and reducing the risk of manual errors.

- Scalability: IaC enables the ability to provision and configure infrastructure resources automatically and at scale, reducing the time and effort required for manual provisioning.

- Agility: Changes to the infrastructure can be made programmatically, allowing for rapid and iterative development and deployment cycles.

- Documentation and visibility: Infrastructure code serves as documentation, providing a clear and centralized view of the infrastructure setup, configurations, and dependencies.

### <a id="tools-used">Tools used</a>

Tools used for implementing Infrastructure as Code include:

- **Configuration management tools** like Ansible, Chef, and Puppet
- **Orchestration tools** like Terraform and CloudFormation
- Cloud-specific tools like Azure Resource Manager and Google Cloud Deployment Manager

## <a id="iac-with-ansible">IaC with Ansible</a>

![Ansible diagram](/images/ansible-diagram.png)

Ansible is a popular **open-source configuration management and automation tool** that can be used for Infrastructure as Code (IaC) practices. It allows you to define and manage infrastructure resources, provision servers, configure software, and orchestrate complex deployments using declarative and idempotent playbooks written in YAML.

Ansible's **simplicity**, **agentless** architecture, **power**, and strong community support make it a popular choice for implementing Infrastructure as Code. It provides a straightforward and efficient way to automate infrastructure management, making it easier to achieve consistency, scalability, and reproducibility across different environments.

We use **configuration management** to **automate and manage the configuration of software systems and infrastructure**. It involves defining, deploying, and maintaining the desired state of configurations across multiple environments. Configuration management tools enable consistent, scalable, and efficient management of configurations, ensuring that systems are correctly set up, properly configured, and easily reproducible. It helps streamline the deployment process, maintain system integrity, enforce standards, track changes, and facilitate efficient collaboration among teams working on complex software projects or large-scale infrastructures.

**Why we use Ansible:**

- **Simple** = few lines of code/commands to set up.
- **Agentless** = the agent nodes do not need Ansible installed. Ansible only needs to be on the controller node. It is no longer necessary to SSH into Agents, as the Ansible Controller is where you do everything.
- **Powerful** = can manage and facilitate 2 - 200 000 servers running anywhere in the world on any cloud platform. The controller could be configured locally or globally, and can easily communicate with all the servers at the same time, do different tasks inside individual servers at the same time.

Ansible can be run: hybrid, cloud-based (globally), or locally.

-- Knowledge Dependencies:

_Ansible was written with Python, thus requires that Python is installed. It uses YAML to interact. You need to know how to code YAML._

_Know how to create/use passwords and SSH keys._

_Requires Vagrant/alternative VM provider installed/available and knowledge on how to use and set up VMs._

[Ansible official page with documentation](https://www.ansible.com/)

<!--- **Key aspects of using Ansible for IaC:**

- Inventory: Ansible uses an inventory file to define the target systems or infrastructure nodes it will manage. The inventory file lists the hosts or groups of hosts that Ansible can connect to and configure. It can be static or dynamic, allowing for flexible scaling and dynamic inventory management.

- Playbooks: Playbooks in Ansible are written in YAML format and describe the desired state of the system or infrastructure. Playbooks consist of a set of tasks, where each task defines a specific action to be performed, such as installing packages, modifying configurations, or restarting services. Playbooks can also include variables, conditionals, and loops for more advanced automation scenarios.

- Modules: Ansible provides a wide range of modules that represent specific actions or tasks that can be executed on target systems. Modules can perform tasks like package installation, file management, service management, user management, and more. Ansible modules are idempotent, meaning they can be executed multiple times without causing undesired changes if the desired state is already achieved.

- Roles: Roles are a way to organize and package related tasks and configurations into reusable units. Roles provide a structured approach to modularize Ansible playbooks and make them more maintainable and shareable. They help promote code reusability across projects and simplify playbook development and management.

- Configuration Management: Ansible allows you to define the desired configuration of your infrastructure by specifying tasks and configurations in playbooks. It can manage configurations for a wide range of systems, including Linux, Windows, network devices, cloud services, and more. Ansible's idempotent nature ensures that configurations are applied consistently and only when necessary.

- Orchestration: Ansible can orchestrate complex deployments and workflows by defining dependencies and executing tasks in a specific order. It provides features like handlers (for triggering actions based on specific events), conditionals, and loops, allowing you to create sophisticated automation scenarios.

- Integration with cloud platforms: Ansible integrates well with various cloud platforms, such as AWS, Azure, Google Cloud, and OpenStack, allowing you to provision and manage cloud resources using Ansible playbooks. It provides modules and plugins specifically designed for interacting with cloud APIs, enabling infrastructure provisioning and configuration management in cloud environments. --->

## <a id="configuration-management-with-ansible">Configuration Management with Ansible</a>

### <a id="ansible-set-up-and-ssh-connections">Ansible Set up and SSH connections</a>

With Vagrantfile in the 'Infrastructure-as-Code' folder:
```shell
# navigates to correct location on your local device
cd ~/Documents/tech_230_sparta/Infrastructure-as-Code

# starts the machines specified in the Vagrantfile
vagrant up

# gives the status of the machines
vagrant status
```
SSH into each VM and ensure internet connection accessible by running update & upgrade:

Controller VM:
```shell
# SSH into controller VM
vagrant ssh controller

# Update and Upgrade to ensure internet connection is available on machine
sudo apt-get update -y && sudo apt-get upgrade -y

# exits VM
exit
```
Web app VM:
```shell
# SSH into web VM
vagrant ssh web

# Update and Upgrade to ensure internet connection is available on machine
sudo apt-get update -y && sudo apt-get upgrade -y

# exits VM
exit
```
Database VM:
```shell
# SSH into db VM
vagrant ssh db

# Update and Upgrade to ensure internet connection is available on machine
sudo apt-get update -y && sudo apt-get upgrade -y

# exits VM
exit
```

Enter controller VM using `vagrant ssh controller` in your bash terminal in the folder you have your Vagrantfile:
```shell
## Set up connections to web and db VMs
# ssh into web VM from controller VM
ssh vagrant@192.168.33.10
# confirm adding host for first time
yes
# enter password as vagrant (do not worry that nothing comes up when typing in the password, it is registering input)
password:vagrant
# check web access
sudo apt update -y
# logout to controller
exit

# ssh into db VM from controller VM
ssh vagrant@192.168.33.11
# confirm adding host for first time
yes
# enter password as vagrant (do not worry that nothing comes up when typing in the password, it is registering input)
password:vagrant
# check web access
sudo apt update -y
# logout to controller
exit

## Install Ansible
# install useful command-line tools, which simplify the process of managing software repositories
sudo apt install software-properties-common
# downloads ansible packages from a repository
sudo apt-add-repository ppa:ansible/ansible #enter
# updates necessary packages for ansible
sudo apt-get update -y
# installs ansible
sudo apt install ansible -y

# checks installation of correct version
sudo ansible --version # ansible 2.9.27

# navigates to default ansible configuration files
cd /etc/ansible
# installs tree = command-line utility that displays directory structures in a tree-like format
sudo apt install tree -y
```
Add agents to Ansible's hosts configuration file:
```shell
# edit /etc/ansible/hosts to contain hosts/agents
sudo nano /etc/ansible/hosts

# create groups or put individual IPs inside hosts including the following:
[web]
192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
[db]
192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
# save and exit
```
Ping your hosts/agents:

```shell
# looks for all agents in hosts file and sends ping requests if found and will respond with 'pong' if successful
sudo ansible all -m ping
# Returns following if no hosts: [WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

# sends ping request to web VM
sudo ansible web -m ping
yes
# returns:
# 192.168.33.10 | SUCCESS => {
#    "ansible_facts": {
#        "discovered_interpreter_python": "/usr/bin/python"
#    },
#    "changed": false,
#    "ping": "pong"
#}

# sends ping request to db VM
sudo ansible db -m ping
yes
# returns:
# 192.168.33.11 | SUCCESS => {
#    "ansible_facts": {
#        "discovered_interpreter_python": "/usr/bin/python"
#    },
#    "changed": false,
#    "ping": "pong"
#}
```
---
**NOTE:**

If you get this error while pinging:
```
192.168.33.11 | FAILED! => {
    "msg": "Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host."
}
```
Edit: `/etc/ansible/ansible.cfg` under '[defaults]' uncomment `host_key_checking = False` and under '[ssh_connection]' paste `host_key_checking = False` to bypass ssh host checking and then ping again. Once ping is successful comment out both `host_key_checking = False` lines in `/etc/ansible/ansible.cfg`.

<!--
sudo ansible all -m ping --ask-vault-pass
password:
-->
### <a id="adhoc-commands-with-ansible">Adhoc Commands with Ansible</a>

Adhoc commands typically follow this format: `ansible <target_hosts> -m <module_name> -a "<module_arguments>"`.

Using adhoc commands allows you to perform quick tasks or execute simple modules on remote hosts managed by Ansible (from the controller VM).

Adhoc commands are useful for performing quick tasks, gathering information, making changes, or running modules on remote hosts without the need to create a full-fledged playbook. They are typically only run once.

Example of adhoc command from the controller VM:
```bash
# uses ansible to get OS of web host
sudo ansible web -a "uname -a"
# returns: Linux
# uses ansible to get OS of db host
sudo ansible db -a "uname -a"
```
Use adhoc command to move files/folders to a target_host(s):
```bash
# create a file on controller
sudo nano test.txt
# write something, save and exit

# move file from controller VM using Adhoc commands to the web host
sudo ansible web -m copy -a "src=/etc/ansible/test.txt dest=/home/vagrant/test"
```
Useful module_arguments:

`-a "uname -a"` gets the Operating System of the target_host(s)

`-a "date"` gets the date and time that the target_host(s) is/are running on

`-a "ls -a"` lists all the files/folders in the target_host(s) home directory

[Ansible - Adhoc commands](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html)

### <a id="ansible-playbooks---yaml">Ansible Playbooks - YAML</a>

**Playbooks** in Ansible are **written in YAML format** and **describe the desired state of the system or infrastructure** (i.e. **configuration files**). Playbooks consist of a **set of tasks**, where each **task defines a specific action to be performed**, such as installing packages, modifying configurations, or restarting services **to be executed on remote systems**. They are **re-usable** (i.e. **idempotent**) - just need to change the hosts and add keys.

![Ansible App Playbook](/images/app-playbook-diagram.png)

![Ansible DB Playbook](/images/ansible-db-playbook-diagram.png)

YAML (YAML Ain't Markup Language) is a human-readable data serialization format. It is often used in configuration files, data exchange, and markup languages.
- indent in YAML = 2 spaces
- YAML uses a hierarchy of key-value pairs to represent data
- `#` used to comment
- emphasizes human readability and simplicity
- created on Linux with `nano <file-name>.yml`
- run on Linux using `ansible-playbook <file-name>.yml`

Playbooks:

- Set up `web` VM: [web_setup_playbook.yml](https://github.com/EstherSlabbert/Infrastructure-as-Code/blob/main/web_setup_playbook.yml) or fragmented [Nginx setup](#ansible-nginx-playbooks), [Copy app](#ansible-copy-app-playbook), [NodeJS setup](#ansible-nodejs-playbook), [Environment variable for connection to DB and start app](#ansible-start-app-playbook).
- Set up `db` VM: [db_setup_playbook.yml](https://github.com/EstherSlabbert/Infrastructure-as-Code/blob/main/db_setup_playbook.yml) or [MongoDB setup](#ansible-set-up-mongodb-playbook).

#### <a id="ansible-nginx-playbooks">Ansible Nginx Playbooks</a>

Nginx install & enable playbook:

1. Create playbook file to install and enable Nginx:
```bash
# create a playbook to install nginx in web-server(s)
sudo nano config_nginx_web.yml #.yaml also works
```
2. In 'config_nginx_web.yml' playbook write the following:
```yaml
# add --- to start YAML file
---
# add name of the host
- hosts: web
# gather additional facts about the steps (optional)
  gather_facts: yes
# add admin access to this file
  become: true
# add instructions (i.e. TASKS) (to install nginx):
# install nginx
  tasks:
  - name: Installing Nginx # Your choice of name
    apt: pkg=nginx state=present # present=enables nginx, state=absent stops/removes
```
3. Run playbook:
```bash
#run playbook file with tasks written in yaml
sudo ansible-playbook config_nginx_web.yml

# check status of nginx to confirm correct set up
sudo ansible web -a "sudo systemctl status nginx"
```

Nginx Reverse Proxy playbook:

```yaml
# add --- to start YAML file
---
# add name of the host
- hosts: web
# gather additional facts about the steps (optional)
  gather_facts: yes
# add admin access to this file
  become: true
# instructions to set up reverse proxy for sparta app port 3000
# replace 'try_files' line with 'proxy_pass' line in this file '/etc/nginx/sites-available/default'
# reload nginx to apply the changes made in the default file
  tasks: 
  - name: Set up Nginx reverse proxy
    replace:
      path: /etc/nginx/sites-available/default
      regexp: 'try_files \$uri \$uri/ =404;'
      replace: 'proxy_pass http://localhost:3000/;'

  - name: Reload Nginx to apply changes
    systemd:
      name: nginx
      state: reloaded
```

#### <a id="ansible-copy-app-playbook">Ansible Copy 'app' Playbook</a>

If app is not on the controller VM already (from setting it up to sync in the Vagrantfile) use this command to copy it over: `scp -r app/ vagrant@192.168.33.12:/home/vagrant/`.

Playbook for copying over the app folder:

1. Create playbook file:
```bash
# create playbook to copy app over to web VM
sudo nano copy_app_over.yml
```
2. Add tasks to playbook file:
```yaml
# start yaml file
---
# state hosts name
- hosts: web
# gather additional facts about the steps (optional)
  gather_facts: yes
# give admin access to this file
  become: true
# task: get app folder on web agent
# copies app from controller path: '/home/vagrant/app' to destination path on web VM: '/home/vagrant/'
  tasks:
  - name: Copy App folder
    copy:
      src: /home/vagrant/app
      dest: /home/vagrant/
```
3. Run playbook:
```bash
# runs playbook file with tasks written in yaml
sudo ansible-playbook copy_app_over.yml

# check status
sudo ansible web -a "ls -a"
```

#### <a id="ansible-nodejs-playbook">Ansible NodeJS Playbook</a>

Playbook to install required version of NodeJS:

1. Create playbook file:
```bash
# create playbook to install nodejs
sudo nano config_install_nodejs.yml
```
2. Add tasks to playbook file:
```yaml
# --- starts YAML file
---
# state hosts name
- hosts: web
# gather additional facts about the steps (optional)
  gather_facts: yes
# give admin access to this file
  become: true
# Install NodeJS 12.x and PM2:
# update system
# install curl
# use curl to execute Node.js setup script to add the repo required
# install nodejs
# install pm2 globally
  tasks:
  - name: Update system
    apt:
      update_cache: yes

  - name: Install curl
    apt:
      name: curl
      state: present

  - name: Add Node.js 12.x repository
    # uses the shell module to run the curl command and execute the Node.js setup script to add the repository
    shell: curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    args:
      warn: false # ignore the warnings and proceed

  - name: Install Node.js
    # uses the apt module to install the nodejs package
    apt:
      name: nodejs
        # state parameter is set to present to ensure Node.js is installed
      state: present
        # update_cache: yes ensures that the package manager cache is updated before installing
      update_cache: yes

  - name: Install pm2 globally
      # ensures admin privileges
    become: true
    command: npm install pm2 -g
```
3. Run playbook:
```bash
# runs playbook
sudo ansible-playbook config_install_nodejs.yml
# checks version of nodejs installed
sudo ansible web -a "node --version"
# checks pm2 installed
sudo ansible web -a "pm2 --version"
```

#### <a id="ansible-set-up-mongodb-playbook">Ansible Set Up MongoDB Playbook</a>

Playbook to connect app to DB to see /posts page.
1. Create the file with: `sudo nano setup_mongo.yml`.

2. Write to the playbook:
```yaml
# Installing required version of mongodb in db-server
# hosts entries are already done - ssh/password authentication in place
---
# hosts name
- hosts: db
# get facts/logs
  gather_facts: yes
# admin access
  become: true
# add instructions:
# install mongodb
  tasks:
  - name: Setting Up MongoDB
    apt: pkg=mongodb state=present
# ensure db is running (status actively running)
# replaces bind_ip to allow access for web to connect to database
  - name: Change BindIP to allow web VM access
    replace:
      path: /etc/mongodb.conf
      regexp: 'bind_ip = 127.0.0.1'
      replace: 'bind_ip = 0.0.0.0'
# uncomments port = 27017
  - name: Ensure port 27017 is uncommented
    replace:
      path: /etc/mongodb.conf
      regexp: '#port = 27017'
      replace: 'port = 27017'
# restarts mongodb with changes made to mongodb.conf
  - name: Restart MongoDB service
    systemd:
      name: mongodb
      state: restarted
# enables mongodb
  - name: Enable MongoDB service
    systemd:
      name: mongodb
      enabled: yes
```
3. Check: `sudo ansible db -a "sudo systemctl status mongodb"` and `sudo ansible db -a "cat /etc/mongodb.conf"`

#### <a id="ansible-start-app-playbook">Ansible Start App Playbook</a>

1. Create playbook:
```bash
# creates yaml playbook file
sudo nano start_app.yml
```
2. Write tasks/instructions in playbook:
```yaml
# Start the web app, 'app.js', found in the app folder:
# --- starts YAML file
---
# states hosts name
- hosts: web
# gather additional facts about the steps (optional)
  gather_facts: yes
# gives admin privileges to this file
  become: true
  tasks:
  - name: Add DB_HOST environment variable to .bashrc
    lineinfile:
      # sets destination to .bashrc file
      path: /home/vagrant/.bashrc
      # specifies line to be added
      line: 'export DB_HOST=mongodb://192.168.33.11:27017/posts'
      # ensures line is added at the end of the file
      insertafter: EOF
      state: present
    notify: Reload bashrc

  - name: Reload bashrc
    shell: source /home/vagrant/.bashrc
    args:
      executable: /bin/bash
# It is set to run asynchronously with async: 0 and poll: 0 to ensure it runs immediately and does not affect subsequent tasks.
    async: 0
    poll: 0
# The changed_when: false directive is added to avoid unnecessary changes reported by Ansible.
    changed_when: false
    
  - name: Stop running app
    shell: npm stop app
    args:
      chdir: /home/vagrant/app

  - name: Install app dependencies
    shell: npm install
    args:
      chdir: /home/vagrant/app
    changed_when: false

  - name: Seed database
    shell: node seeds/seed.js
    args:
      # changes to correct directory
      chdir: /home/vagrant/app
      # ignores warnings
      warn: false

  - name: Run npm start in the background
    shell: "cd /home/vagrant/app && nohup npm start > /dev/null 2>&1 &"
    args:
      executable: /bin/bash

```
3. Run playbook:
```bash
# runs playbook
sudo ansible-playbook start_app.yml
# checks changes to .bashrc
sudo ansible web -a "cat ~/.bashrc"
# checks status of app running
sudo ansible web -a "pm2 status"
```
Go to the [web VM's IP](http://192.168.33.10/) in your web browser to see if app is running, then try the [/posts page](http://192.168.33.10/posts) and [/fibonnacci/10 page](http://192.168.33.10/fibonacci/10).

## <a id="iac-with-terraform">IaC with Terraform</a>

Terraform is an **Orchestration tool**. Terraform is an **open-source** infrastructure as code (IaC) tool developed by HashiCorp. It **enables you to define and provision infrastructure resources across various cloud providers and on-premises environments in a declarative and version-controlled manner**.

Provision configuration file configures and deploys on Cloud Platform by any Cloud Service Provider if provided with the correct security permissions.

![Terraform diagram](/images/terraform-diagram.png)

Terraform controls 1 with about 10 lines of code. Ansible would use about 50 lines of code, but could configure thousands at once.

With Terraform, you can describe your desired infrastructure configuration using a domain-specific language (DSL) called HashiCorp Configuration Language (HCL) or JSON. This configuration defines the desired state of your infrastructure, including resources such as virtual machines, networks, storage, security groups, and more.

- .tf execution file
- Need secret and access keys, have admin access on local machine, use git bash, and know how to set permanent environment variable

[Terraform documentation](https://developer.hashicorp.com/terraform/docs)

### <a id="install-terraform-on-windows">Install Terraform on Windows</a>

1. Go to this site: [Hashicorp - Terraform download](https://developer.hashicorp.com/terraform/downloads) and download the version of Terraform you want.
2. Create a folder in `C:\` called `terraform`.
3. Move the zipped download to `C:\terraform`.
4. Extract the zipped files and move the terraform application file into `C:\terraform` so it looks like this:

![terraform folder](/images/terraform-install-folder.png)

5. Use the search bar to open `Settings` and use its search bar to look up 'environment variables' and click on `Edit the system environment variables`:

![Environment variable 1](/images/terraform-install-system-env-variable1.png)

6. It should pop up with 'System Properties' and under the 'Advanced' tab click on `Environment Variables...`:

![Environment variable 2](/images/terraform-install-system-env-variable2.png)

7. It should pop up with 'Environment Variables' and under the 'System variables' click `New`:

![Environment variable 3](/images/terraform-install-system-env-variable3.png)

8. It should pop up with 'New System Variable'. In the 'Variable name:' box type `Path` and in the 'Variable value:' box type `C:\terraform`. Then click `OK` for all the pop ups to save and close them.

![Environment variable 4](/images/terraform-install-system-env-variable4.png)

9. Verify Terraform's installation in the Git Bash terminal using `terraform --version` to see the version installed or in the standard command terminal `terraform`, which should return a list of commands if terraform installed successfully.

If you have a different operating system see the following: [Spacelift guide to install Terraform](https://spacelift.io/blog/how-to-install-terraform).

### <a id="Setup-terraform-to-interact-with-aws-and-launch-an-ec2">Setup Terraform to interact with AWS and launch an EC2</a>

1. Add environment variables to account named `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY_ID` with their respecitve keys as the variables.

2. Create a `main.tf` file in Git Bash (opened as admin) in a Terraform folder using `nano main.tf`.

3. Write to main.tf, then save and exit:
```terraform
# To create a service on AWS cloud
# launch an ec2 in Ireland
# terraform to download required packages
# to run: terraform init

provider "aws" {
# which regions of AWS
        region = "eu-west-1"

}
# git bash must have admin access
# can run 'terraform init' here
# Launch an ec2

# which resource -
resource "aws_instance" "app_instance"{

# which AMI - ubuntu 18.04
        ami = "<ami-id>"

# type of instance t2.micro
        instance_type = "t2.micro"

# do you need public IP = yes
        associate_public_ip_address = true

# what would you like to call it
        tags = {
                Name = "<name-of-instance>"
}

}
```
4. `terraform init` - initializes terraform.
5. `terraform plan` - checks code to see what is executable/ if any errors.
6. `terraform apply` - will ask for confirmation `yes` then will launch service (i.e. EC2 instance) outlined in `main.tf`.
7. `terraform destroy` - will ask for confirmation `yes` then terminates service (i.e. EC2 instance) outlined in `main.tf`.

### <a id="terraform-create-two-tier-vpc-and-ec2-instances">Terraform create two-tier VPC and EC2 instances</a>

[Terraform documentation on VPCs with AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

Steps to automate setting up a VPC for a 2-tier architecture deployment of a database and the Sparta Provisioning Test App to display the Sparta home page, /posts page and /fibonacci/10 page using the web app server's public IP address:

1. Create a file called `main.tf` or another name in a folder. (If not done already: Add environment variables to account named `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY_ID` with their respecitve keys as the variables.)
2. Write the following template to your terraform file and edit (Remember to change the names of each resource, use appropriate CIDR blocks, and add the AMI IDs and your own IP where needed):
```terraform
# define provider and region
provider "aws" {
	region = "eu-west-1" # specify the region you are working with
}

# VPC and dependencies

# create vpc
resource "aws_vpc" "my_vpc" {
# specify CIDR block
	cidr_block = "10.0.0.0/16" # replace with your used CIDR block
# name vpc
	tags = {
		Name = "<name-of-vpc>" # replace with desired name
	}
}

# create internet gateway (igw)
resource "aws_internet_gateway" "igw" {
# link igw to vpc
	vpc_id = aws_vpc.my_vpc.id
# name igw
	tags = {
		Name = "<name-of-igw>" # replace with desired name
	}
}

# create private subnet within vpc
resource "aws_subnet" "private_subnet" {
# attach subnet to specified vpc
  vpc_id = aws_vpc.my_vpc.id
# specify CIDR block for subnet
  cidr_block = "10.0.3.0/24" # replace with your used CIDR block
# name subnet
  tags = {
          Name = "<name-of-private-subnet>" # replace with desired name
  }
}

# create public subnet within vpc
resource "aws_subnet" "public_subnet" {
# attach subnet to specified vpc
  vpc_id = aws_vpc.my_vpc.id
# specify CIDR block for subnet
  cidr_block = "10.0.2.0/24" # replace with your used CIDR block
# name subnet
  tags = {
          Name = "<name-of-public-subnet>" # replace with desired name
  }
}

# create public route table
resource "aws_route_table" "public_route_table" {
# link to vpc
	vpc_id = aws_vpc.my_vpc.id
# name route table
	tags = {
		Name = "<name-of-public-route-table>" # replace with desired name
	}
}

# creating route in public route table and associates with igw
resource "aws_route" "public_route" {
# specifies this route table for association with igw
	route_table_id = aws_route_table.public_route_table.id
# routes all traffic to igw
	destination_cidr_block = "0.0.0.0/0"
# specifies association to this igw
	gateway_id = aws_internet_gateway.igw.id
}

# associates public route table with public subnet
resource "aws_route_table_association" "public_subnet_association" {
# specifies subnet to be associated
	subnet_id = aws_subnet.public_subnet.id
# specifies route table to be associated
	route_table_id = aws_route_table.public_route_table.id
}

# Security Groups

# Create security group for web app server
resource "aws_security_group" "app-server-sg" {
	name        = "<name-of-app-server-security-group>" # replace with desired name
	description = "Security group for Sparta Provisioning Test App web server"
	vpc_id      = aws_vpc.my_vpc.id

	# Inbound rule for SSH access from my IP
	ingress {
    # SSH port
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		# specifies my ip so I can access the app server via ssh
		cidr_blocks = ["<my-ip>/32"] # replace <my-ip> with actual IP
	}
  
	# Inbound rule for HTTP access from all
	ingress {
    # HTTP port
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
    # all access allowed
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Inbound rule for port 3000 access from all
	ingress {
    # in case where the app server does not have a reverse proxy set up
		from_port   = 3000
		to_port     = 3000
		protocol    = "tcp"
    # all access allowed
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Inbound rule for MongoDB access from private subnet
	ingress {
    # default mongodb port
		from_port   = 27017
		to_port     = 27017
		protocol    = "tcp"
		# specifies private subnet CIDR block for connecting with DB
		cidr_blocks = ["10.0.3.0/24"]
	}

	# Outbound rule allowing all traffic
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
    # all access allowed
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# Create security group for DB server
resource "aws_security_group" "db-server-sg" {
	name        = "<name-of-db-server-security-group>" # replace with desired name
	description = "Security group for MongoDB server"
	vpc_id      = aws_vpc.my_vpc.id

	# Inbound rule for MongoDB access from app server in public subnet
	ingress {
    # default mongodb port
		from_port        = 27017
		to_port          = 27017
		protocol         = "tcp"
    # specifies public subnet cidr block for connecting with app
		cidr_blocks = ["10.0.2.0/24"]
	}

	# Outbound rule allowing all traffic
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# Launch EC2 instances from AMIs

# Launch DB server EC2 instance in private subnet
resource "aws_instance" "db-server" {
	# ami for db
	ami           = "<ami-id>" # replace <ami-id> with actual ami id of working db
  # specifies instance type
	instance_type = "t2.micro"
  # specifies key name for key pair
	key_name      = "tech230" # replace with assigned key name
  # associates this ec2 with the private subnet in the vpc
	subnet_id     = aws_subnet.private_subnet.id
  # fixes private IP address
  private_ip    = "10.0.3.100" # specify desired private IP
  # assigns relevant security group
	vpc_security_group_ids = [aws_security_group.db-server-sg.id]

	tags = {
		Name = "<name-of-db-ec2-instance>" # replace with desired name
	}
}

# Launch app server EC2 instance in public subnet
resource "aws_instance" "web-app-server" {
	# ami for app
	ami           = "<ami-id>" # replace <ami-id> with actual ami id for default ubuntu 20.04 instance
  # specifies instance type
	instance_type = "t2.micro"
  # specifies key pair name
	key_name      = "tech230" # replace with your assigned key name
  # associates ec2 with public subnet in vpc
	subnet_id     = aws_subnet.public_subnet.id
  # assigns relevant security group
	vpc_security_group_ids = [aws_security_group.app-server-sg.id]
  # ensures this EC2 instance has a public IP
	associate_public_ip_address = true
  # ensures this ec2 only runs after db one as db is required for app to connect to
  depends_on = [aws_instance.db-server]
  # user data to setup and run the app on this instance
  user_data = <<-EOF
    #!/bin/bash

    # Update the sources list and Upgrade any available packages
    sudo apt update -y && sudo apt upgrade -y

    # gets sources list that could potentially be needed for the following installations
    sudo apt update

    # Installs Nginx
    sudo apt install nginx -y

    # setup nginx reverse proxy
    sudo apt install sed
    # $ and / characters must be escaped by putting a backslash before them
    sudo sed -i "s/try_files \$uri \$uri\/ =404;/proxy_pass http:\/\/localhost:3000\/;/" /etc/nginx/sites-available/default
    # restart nginx to get reverse proxy working
    sudo systemctl restart nginx

    # Installs git
    sudo apt install git -y

    # sets source to retrieve nodejs
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

    # installs node.js
    sudo apt install -y nodejs

    # Enables Nginx to run on start up of API or VM
    sudo systemctl enable nginx

    #echo "export DB_HOST=mongodb://10.0.3.100:27017/posts" >> ~/.bashrc
    #source ~/.bashrc
    # REMEMBER TO CHANGE IP if the mongoDB server private IP changed
    export DB_HOST=mongodb://10.0.3.100:27017/posts

    # clone repo with app folder into folder called 'repo'
    git clone https://github.com/daraymonsta/CloudComputingWithAWS repo

    # install the app (must be after db vm is finished provisioning)
    cd repo/app
    npm install

    # seed database
    echo "Clearing and seeding database..."
    node seeds/seed.js
    echo "  --> Done!"

    # start the app (could also use 'npm start')

    # using pm2
    # install pm2
    sudo npm install pm2 -g
    # kill previous app background processes
    pm2 kill
    # start the app in the background with pm2
    pm2 start app.js
  EOF

	tags = {
		Name = "<name-of-web-app-server>" # replace with desired name
	}
}
```
3. Initialize your terraform file with `terraform init` or `terraform init -var-file=/path/to/your/terraform-file.tf` (replace with actual path to terraform file).
4. Check your code with `terraform plan`  or `terraform plan -var-file=/path/to/your/terraform-file.tf` (replace with actual path to terraform file).
5. If you are satisfied run your code with `terraform apply`  or `terraform apply -var-file=/path/to/your/terraform-file.tf` (replace with actual path to terraform file) and confirm by entering `yes`.
6. Log in to AWS and get the public IP from your web app EC2 instance and go to the page of the IP, '/posts' and '/fibonacci/10' of the app in your web browser.
7. If you wish to delete/remove all you added to AWS run `terraform destroy`  or `terraform destroy -var-file=/path/to/your/terraform-file.tf` (replace with actual path to terraform file) and confirm by entering `yes`.