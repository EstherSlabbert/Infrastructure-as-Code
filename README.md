# Infrastructure as Code (IaC)
- [Infrastructure as Code (IaC)](#infrastructure-as-code-iac)
  - [What is IaC?](#what-is-iac)
    - [Benefits:](#benefits)
    - [Tools used](#tools-used)
  - [IaC with Ansible](#iac-with-ansible)
  - [Configuration Management with Ansible](#configuration-management-with-ansible)

## <a id="what-is-iac">What is IaC?</a>

Infrastructure as Code (IaC) is a software engineering approach and practice that involves **managing and provisioning computing infrastructure resources automatically** using machine-readable configuration files or scripts. Instead of manually setting up and configuring servers, networks, and other infrastructure components, IaC allows developers and system administrators to define and manage their infrastructure using code.

<!--- With Infrastructure as Code, the entire infrastructure stack, including servers, networks, storage, and other resources, is described and managed through code, typically in a declarative or imperative programming language. The code defines the desired state of the infrastructure, specifying how it should be provisioned, configured, and deployed. --->

### <a id="benefits">Benefits:</a>

By treating infrastructure as code, organizations can achieve **greater efficiency**, **consistency**, **scalability**, and **automation** in managing their computing infrastructure, making it **easier to deploy and manage applications in a reliable and reproducible manner**.

- Version control: Infrastructure code can be stored in version control systems, allowing teams to track changes, collaborate, and roll back to previous versions if needed.

- Reproducibility: Infrastructure can be reliably reproduced across different environments, ensuring consistency and reducing the risk of manual errors.

- Scalability: IaC enables the ability to provision and configure infrastructure resources automatically and at scale, reducing the time and effort required for manual provisioning.

- Agility: Changes to the infrastructure can be made programmatically, allowing for rapid and iterative development and deployment cycles.

- Documentation and visibility: Infrastructure code serves as documentation, providing a clear and centralized view of the infrastructure setup, configurations, and dependencies.

### <a id="tools-used">Tools used</a>

Common tools used for implementing Infrastructure as Code include:

- Configuration management tools like Ansible, Chef, and Puppet
- Orchestration tools like Terraform and CloudFormation
- Cloud-specific tools like Azure Resource Manager and Google Cloud Deployment Manager

## <a id="iac-with-ansible">IaC with Ansible</a>

Ansible is a popular **open-source configuration management and automation tool** that can be used for Infrastructure as Code (IaC) practices. It allows you to define and manage infrastructure resources, provision servers, configure software, and orchestrate complex deployments using declarative and idempotent playbooks written in **YAML**.

Ansible's **simplicity**, **agentless** architecture, **power**, and strong community support make it a popular choice for implementing Infrastructure as Code. It provides a straightforward and efficient way to automate infrastructure management, making it easier to achieve consistency, scalability, and reproducibility across different environments.

**Why we use Ansible:**

- Simple = few lines of code to set up.
- Agentless = the agent nodes do not need Ansible installed. Ansible only needs to be on the controller node. It is no longer necessary to SSH into Agents, the Ansible Controller is where you do everything.
- Powerful = can run over 200 servers.

Dependencies:

Written with Python. Use YAML to interact.

How to create/use passwords and SSH keys.

Requires Vagrant/alternative VM provider.

Can be hybrid, cloud, local.

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

With Vagrantfile in the 'Infrastructure-as-Code' folder:
```shell
# navigates to correct location on your local device
cd ~/Documents/tech_230_sparta/Infrastructure-as-Code

# starts the machines specified in the Vagrantfile
vagrant up

# gives the status of the machines
vagrant status
```

```shell
# SSH into controller VM
vagrant ssh controller

# Update and Upgrade to ensure internet connection is available on machine
sudo apt-get update -y && sudo apt-get upgrade -y

# exits VM
exit
```

```shell
# SSH into web VM
vagrant ssh web

# Update and Upgrade to ensure internet connection is available on machine
sudo apt-get update -y && sudo apt-get upgrade -y

# exits VM
exit
```
```shell
# SSH into db VM
vagrant ssh db

# Update and Upgrade to ensure internet connection is available on machine
sudo apt-get update -y && sudo apt-get upgrade -y

# exits VM
exit
```