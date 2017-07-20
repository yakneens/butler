.. highlight:: rst

.. role:: python(code)
    :language: python
    
.. role:: shell(code)
    :language: shell
    
.. role:: sql(code)
    :language: sql

==================
Installation Guide
==================

Butler installation proceeds through a series of stages each of which is described below and further expanded 
in the :doc:`Reference Guide<reference>`. They are:

* :ref:`Cluster Provisioning/Deployment<cluster_deployment_section>`
* :ref:`Software Configuration<software_configuration_section>`
* :ref:`Workflow/Analysis Configuration<workflow_configuration_section>`
* :ref:`Workflow Test Execution<test_execution_section>`

It is important to distinguish between test and production deployments of Butler. The key distinction between 
these is that a test deployment is typically on a small scale and involves a minimum number of configurations
that can be performed directly in a fork of the Butler repository. A production deployment is not only on a
larger scale but also typically involves the creation of an additional git repository that holds the necessary
configurations, customizations, workflows, analyses, and scripts that arise from production usage of the system.
The scope of this guide covers a test deployment scenario, while the :doc:`Reference Guide<reference>` contains 
additional information useful for production scenarios.

The Butler git repository contains a folder called *examples* which houses the files necessary to perform test
deployments of the system to a variety of cloud computing environments (Openstack, AWS, Azure), as well as some
example workflows, analysis configurations, test data, and useful scripts. Adopting these to your own needs is
often the easiest way to move forward.

.. _cluster_deployment_section:

Cluster Provisioning/Deployment
-------------------------------

Provisioning of a Butler cluster is accomplished using the Terraform open-source library which contains modules
that translate Terraform-formatted configuration files into native API calls for over 15 different cloud providers.
Butler ships with example configurations for the most popular cloud providers (Openstack, AWS, Azure) that you can
use to easily deploy to these clouds. This section outlines the general steps of Terraform-based Butler deployments 
while cloud-specific deployment topics are covered in corresponding sub-sections.

To start your Butler deployment you need 3 things:

* An account on a supported cloud provider with API access to create Virtual Machines (login credentials, API URL).
* Installation of Terraform CLI on a machine that can communicate over the network with your cloud API of choice.
* A set of Terraform configuration scripts that define your deployment specifics (e.g. https://github.com/llevar/butler/tree/master/examples/deployment)

To deploy to any cloud you will need a set of credentials. These are typically some subset of username/password, 
API key, API URL. You will also want to have an SSH keypair ready. Your public key will be put on the VMs you
create so that you can actually SSH onto them.

Butler deployments can be triggered from any machine that has API access to the target cloud. This is typically
your local machine or a designated VM on the same cloud. You can get the latest Terraform CLI from their download
page - https://www.terraform.io/downloads.html.

At this point you should clone the Butler git repo to the machine you are deploying Butler from.

.. code-block:: shell

	git clone https://github.com/llevar/butler
	
Navigate to the examples/deployment subdirectory to see configuration files relevant to your cloud providers of
choice.

.. _openstack_terraform_files:
.. figure:: images/openstack_deployment_file_structure.png  

   Typical Terraform configuration files for a Butler deployment.
   
:numref:`openstack_terraform_files` shows the typical layout for a Butler deployment directory. Each file ending in
:shell:`.tf` is a Terraform configuration file that is responsible for some aspect of the deployment. Other auxiliary
files are used to provide initial configurations for the VMs as they are created.

Using Terraform you are going to set up networking for your deployment (:shell:`network.tf`), set up security groups
(:shell:`security.tf`), and launch various VMs (:shell:`saltmaster.tf, worker.tf` etc.).

It is possible to deploy Butler in many different ways depending on the scale of analysis that is being performed. In
the examples each major component is deployed onto its own VM except for the Monitoring Server which is co-located with
the Configuration Server. These components are as follows:

* :shell:`saltmaster.tf` - The saltmaster is a VM that plays a dual role. It is a Configuration Server - a machine that
  is responsible for managing the configuration state of all VMs in a Butler cluster. It is a Monitoring Server - a
  machine that all the other VMs send their health metrics and logs to. This dual role is possible because configuration
  mostly happens when the cluster is first launched, and only sporadically after, when new machines are added, otherwise
  the machine's resources are free for other uses such as monitoring.  
* :shell:`tracker.tf` - The tracker is a VM that hosts various workflow engine components including the workflow scheduler
  and the tracker Python module and CLI, which is the main interface to Butler.
* :shell:`job-queue.tf` - The job-queue VM runs a RabbitMQ distributed queue that holds various tasks that have been
  scheduled for execution by the workflow scheduler.
* :shell:`db-server.tf` - The db-server VM is a database server that runs PostgreSQL Server with a number of databases that
  are used by Butler, including the run-tracking-db which keeps track of workflows, analyses, and their execution state.
* :shell:`worker.tf` - The workers are VMs that do the actual computational work specified in workflow definitions. These 
  machines talk to the job queue and pick up executable tasks when they are free. They periodically report status back to
  the tracker. 
   
Each Terraform configuration file that defines VMs has a similar structure. A VM needs to have a name, flavour, base image,
network, security groups, and SSH connection info. See :numref:`aws_terraform_basic_params`

.. _aws_terraform_basic_params:
.. code-block:: shell
	:caption: Basic VM parameters (AWS)
	
	ami = "${lookup(var.aws_amis, var.region)}"
	instance_type = "t2.micro"
	associate_public_ip_address = true  
	tags {
		Name = "salt-master"
	}
  
	vpc_security_group_ids = ["${aws_security_group.butler_internal.id}"]
	subnet_id = "${aws_subnet.butler.id}"

	key_name = "${aws_key_pair.butler_auth.id}"
  
	connection {
	  type     = "ssh"
	  user     = "${var.username}"
	  private_key = "${file(var.private_key_path)}"
	  bastion_private_key = "${file(var.private_key_path)}"
	  bastion_host = "${aws_instance.butler_jump.public_ip}"
	  bastion_user = "${var.username}"
	  host = "${aws_instance.salt_master.private_ip}"
	}
	
Once the VM is launched and reachable via SSH Terraform will use a number of :shell:`provisioners` to upload any necessary setup
files or execute the first set of commands. See :numref:`aws_terraform_provisioners`

.. _aws_terraform_provisioners:
.. code-block:: shell
	:caption: VM provisioners
	
	provisioner "file" {
	  source = "../../../../provision/base-image/install-packages.sh"
	  destination = "/tmp/install-packages.sh"
	}
	provisioner "remote-exec" {
	  inline = [
	    "chmod +x /tmp/install-packages.sh",
	    "/tmp/install-packages.sh"
	  ]
	} 

Terraform has a concept of variables and most of the settings you will want to configure from deployment to deployment are
parametrized and extracted into a single file called :shell:`vars.tf`. When you populate variable values in this file they
will be substituted into various other configurations as necessary. From time to time you may want to change a value that
is not exposed through :shell:`vars.tf` you will then need to edit one of the configuration files directly.

The Terraform CLI has a few commands that are well documented on their website (https://www.terraform.io/docs/index.html). 
The most useful ones for Butler are:

* :shell:`terraform plan` - Display the sequence of commands that Terraform will run based on the supplied configurations.
* :shell:`terraform apply` - Execute the actual configurations defined in your :shell:`.tf` files launching VMs as needed.
* :shell:`terraform destroy` - Destroy all of the objects specified in the :shell:`.tf` files.

When you run :shell:`terraform apply` Terraform creates a tree structure of the intended infrastructure and its status and
stores it in a file called :shell:`terraform.tfstate`. If not all of the infrastructure is successfully created when you run
:shell:`terraform apply` then :shell:`terraform.tfstate` will reflect that. You can make necessary changes and safely run 
:shell:`terraform apply` again and things will pick up where they were left off. If you damage or destroy your :shell:`terraform.tfstate`
file the next time you run :shell:`terraform apply` all of your infrastructure will be created from scratch. It can be a good
idea to check this file into source control after making sure it does not contain any secrets you want to keep. 

Now that you have some idea of what Terraform is doing to deploy Butler clusters you should follow one of the platform specific 
deployment sections below to launch your first Butler cluster.

Deployment on OpenStack
```````````````````````

We will be using the Terraform configuration files found at examples/deployment/openstack/large-cluster to deploy our Butler
cluster on OpenStack. These values can be populated directly into the respective variables inside :shell:`vars.tf` file.
Alternatively you can create a separate file with the extension :shell:`.tfvars` which contains a list of key/value pairs
(:shell:`variable_name = variable_value`) that are used to assign values to these variables. Since this file is likely to contain 
sensitive information it is a good idea to add it to your :shell:`.gitignore` so that you don't check it in by accident. 
You can also supply variable values as environment variables with the form :shell:`TF_VAR_variable_name`.

Variables you need to set:

* :shell:`user_name` - Username for authentication with OpenStack API
* :shell:`password` - Password for authentication with OpenStack API
* :shell:`auth_url` - Openstack Auth URL (something like https://my_api_endpoints:13000/v2.0)
* :shell:`tenant_name` - Name of your tenant on OpenStack
* :shell:`main_network_id` - ID of the main network your hosts belong to (get this from OpenStack console).
  If you have multiple networks you will need to configure them inside the individual :shell:`.tf` files or 
  parametrize them out to :shell:`vars.tf`.
* :shell:`key_pair` - Name of the keypair you have added to OpenStack. This public key will be put on the VMS you create
  so that you can SSH to them.
* :shell:`user` - Username that can be used to SSH to the VMs
* :shell:`key_file` - Path on the local machine to the private SSH key you will use to connect to your VMs
* :shell:`bastion_host` - IP of the bastion host (if you are using one, more on this below)
* :shell:`bastion_user` - Username that can be used to SSH to the bastion host (if you are using a bastion)
* :shell:`bastion_key_file` - Path to private key for login to the bastion host (if you are using a bastion)
* :shell:`image_id` - ID of the base VM image that you will use to launch VMs (get this from OpenStack console).
* :shell:`floatingip_pool` - Name of floating IP pool (if used)
* :shell:`worker_count` - Number of workers to launch. Set this to a small number (like 1) for your first couple
  of launches.
* :shell:`main-security-group-id` - ID of the default security group used by your hosts (get this from OpenStack console).

It is usually a good idea from a security standpoint to limit access to your VMs from the outside world. Thus, it is advisable
to set up a separate VM (the bastion host) which will be the only host on your cluster with a public IP and have all the other
hosts reside on a private subnet such that they can be tunneled into via the bastion host. You should further limit access by 
restricting SSH access to the bastion to a whitelist of trusted IPs or subnets. To facilitate deployment in this scenario
populate the bastion variables that have been described above.

Each Butler VM that you deploy has a specific OpenStack VM flavor. If you have non-standard flavor names on your deployment or you wish to
use non-default values then you can populate the following variables:

* :shell:`salt-master-flavor`
* :shell:`worker-flavor`
* :shell:`db-server-flavor`
* :shell:`job-queue-flavor`
* :shell:`tracker-flavor`

Once you have populated these variables with values you are ready for deployment. Run :shell:`terraform plan -var-file path_to_your_vars_file.tfvars`
to see what actions Terraform is planning to take based on your configurations. If you are satisfied then you are ready to run
:shell:`terraform apply -var-file path_to_your_vars_file.tfvars`. This will launch your Butler cluster into existence over the course
of about 10-20 minutes depending on size. If all is well you will see a message at the end that your resources have been successfully created.
You are now ready to move on to the Software Configuration stage of the deployment.

When you are done with your cluster you can cleanly tear it down by running :shell:`terraform destroy -var-file path_to_your_vars_file.tfvars`

Troubleshooting OpenStack Deployments
'''''''''''''''''''''''''''''''''''''

Terraform is pretty good about printing out information about error conditions that occur, thus, if you find yourself with repeated failures
to deploy you should closely examine the program output to see if it contains the information for pinpointing the cause of the failure. Most often
the errors revolve around misspellings of usernames, flavors, API endpoints and so on, or inappropriate SSH credentials. If you are not finding
the default information provided to be sufficient you can enable debug output by setting the :shell:`TF_LOG=DEBUG` environment variable where you
run terraform from. This will produce a lot of output but it can help figure out what the issue is. Additionally, because Terraform makes OpenStack
API requests on your behalf, the errors it encounters are not always adequately represented in the output. You can enable OpenStack specific debug
output by setting the :shell:`OS_DEBUG=1` environment variable which will allow you to inspect the individual OpenStack API calls that are being made
and the responses that are being received. Once you are done debugging it is highly recommended to unset these variables.

 	
.. _software_configuration_section:

Software Configuration
----------------------

.. _workflow_configuration_section:

Workflow/Analysis Configuration
-------------------------------

.. _test_execution_section:

Workflow Test Execution
-----------------------

