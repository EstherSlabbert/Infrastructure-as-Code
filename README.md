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
      - [Ansible Start App Playbook](#ansible-start-app-playbook)
      - [Ansible Set Up MongoDB Playbook](#ansible-set-up-mongodb-playbook)

## <a id="what-is-iac">What is IaC?</a>

Infrastructure as Code (IaC) is a software engineering approach and practice that involves **managing and provisioning computing infrastructure resources automatically** using machine-readable configuration files or scripts. Instead of manually setting up and configuring servers, networks, and other infrastructure components, IaC allows developers and system administrators to define and manage their infrastructure using code.

**Infrastructure code = code that we write for machines to understand.**

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
<!---
If you get this error while pinging:
```bash
192.168.33.11 | FAILED! => {
    "msg": "Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host."
}
```
Edit: /etc/ansible/ansible.cfg under '[defaults]' uncomment 'host_key_checking = False' and under '[ssh_connection]' paste 'host_key_checking = False' to bypass ssh host checking
--->

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
<!-- Default ansible file structure:
/etc/ansible/hosts stores hosts/agents addresses
/etc/ansible/ansible.conf contains ansibles configurations

sudo ansible all -m ping --ask-vault-pass
password: -->
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
Use adhoc command to move files/folders to a target_host(s)
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

![Ansible Playbooks](/images/playbook.png)

YAML (YAML Ain't Markup Language) is a human-readable data serialization format. It is often used in configuration files, data exchange, and markup languages.
- indent in YAML = 2 spaces
- YAML uses a hierarchy of key-value pairs to represent data
- `#` used to comment
- emphasizes human readability and simplicity

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

#### <a id="ansible-start-app-playbook">Ansible Start App Playbook</a>

1. Create playbook:
```bash
# creates yaml playbook file
sudo nano start_app.yml
```
2. Write tasks/instructions in playbook:
```yaml
# --- starts YAML file
---
# states hosts name
- hosts: web
# gather additional facts about the steps (optional)
  gather_facts: yes
# gives admin privileges to this file
  become: true
# Start app.js in the app folder:
# install app dependencies in the app folder
# use pm2 to start app.js in the app folder
  tasks:  
  - name: Install app dependencies
    shell: npm install
    args:
      # changes to correct directory
      chdir: /home/vagrant/app

  - name: Start the app with PM2
    shell: pm2 start app.js
    args:
      # changes to correct directory
      chdir: /home/vagrant/app
```
3. Run playbook:
```bash
# runs playbook
sudo ansible-playbook start_app.yml
```
Go to the web VM's IP (192.168.33.10) in your web browser to see if app is running.

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
```
3. Check: `sudo ansible db -a "sudo systemctl status mongodb"`

Automate:

`ssh vagrant@192.168.33.11` db

`sudo nano /etc/mongodb.conf` change `bind_ip = 127.0.0.1` to `bind_ip = 0.0.0.0`, ensure `#port = 27017` is uncommented as `port = 27017`.

`sudo systemctl restart mongodb`

`sudo systemctl enable mongodb`

`sudo systemctl status mongodb`

web VM:

`ssh vagrant@192.168.33.10` web

`export DB_HOST=192.168.33.11:27017/posts` then `cd app`, `pm2 start app.js --update-env` if it works make it persistent by adding it to the .bashrc file.


<!-- ## <a id="iac-with-terraform">IaC with Terraform</a>

Terraform is an Orchestration tool. -->
