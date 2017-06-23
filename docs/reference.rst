=======================
Reference Documentation
=======================

System Design
-------------

General Design Principles
`````````````````````````

To address the need for a large-scale cloud-based distributed workflow system that is suitable to scientific computing 
applications we present the design of our framework called Butler.

Although a detailed description of system Architecture and Design follows, we begin by describing several guiding 
principles that have been adopted in the design of this system:

* Existing Open-Source Software
* Service Orientation
* Cloud Agnosticity
* Open-Source License

Existing Open-Source Software
'''''''''''''''''''''''''''''

The scope of the requirements for a workflow system of the nature described in this work are quite vast and building 
such a system from scratch would take years of effort from an entire software team. On the other hand, many of the 
of the systems can be readily met via existing software products. Although commercial software products tend to have 
better technical support, in the interest of cost savings, and in order to keep the entire solution open source we 
have opted to use all Open Source Software components when building Butler.

Since keeping the amount of new code that needed to be written to build Butler to a minimum was one of the cornerstones 
of system design, a very substantial portion of the overall system 
consists of 3rd party OSS frameworks that are integrated together to produce Butler. These include:

===================  ===========================================  ============================
Product              URL                                          Role
===================  ===========================================  ============================
Hashicorp Terraform  https://github.com/hashicorp/terraform       Cluster Lifecycle Management
Hashicorp Consul     https://github.com/hashicorp/consul          Service Discovery and Service Health Checking
Saltstack            https://github.com/saltstack/salt            Cluster Configuration Management
Apache Airflow       https://github.com/apache/incubator-airflow  Workflow Management
RabbitMQ             https://github.com/rabbitmq/rabbitmq-server  Queuing
Celery               https://github.com/celery/celery             Task Scheduling
Collectd             https://github.com/collectd/collectd         Metrics Collection
InfluxData InfluxDB  https://github.com/influxdata/influxdb       Metrics Storage
Grafana              https://github.com/grafana/grafana/          Metrics Dashboards
Logstash             https://github.com/elastic/logstash          Log Harvesting
Elasticsearch        https://github.com/elastic/elasticsearch     Log Indexing and Aggregation
Kibana               https://github.com/elastic/kibana            Log Event Dashboards 
===================  ===========================================  ============================

These products were selected based on their ability to fulfill the specified requirements as well as their overall viability 
as Open Source projects. 

Service Orientation
'''''''''''''''''''
One of the key requirements for Butler is Scalability i.e. the desire to be able to scale the amount of resources utilized by 
the framework up and down arbitrarily according to analysis needs. Applications that are monolithic in nature suffer from 
scalability issues due the large number of competing constraints within application components. To help alleviate this 
concern we take a Service Oriented approach in the design of the system. Butler is composed of a number of loosely coupled 
services each of which implements a particular function. Because the services are decoupled, each service can be optimized 
and scaled individually, according to user requirements. On the other hand, the complexity of the overall application is 
increased somewhat because of the need to deploy and manage separate services that are in communication with each other.

Another benefit of Service Orientation is the ability to independently upgrade components of the software without affecting 
other running components. As an example, the Collectd metrics collection component can be patched independently of the rest 
of the system, thus increasing system Availability.

Cloud Agnosticity
'''''''''''''''''
Each of the top 4 cloud service providers - Amazon, Google, IBM , Microsoft, as well as smaller cloud providers that use the 
Openstack platform, provides not only the basic IaaS offering, but also an entire ecosystem of cloud based components - a PaaS, 
including networking, queues, databases, etc. Thus, it may be tempting to select one of these providers and build an entire software 
system that is based on a single vendor's offerings. This has the potential benefit of significantly simplifying system architecture 
and providing a single point of contact for troubleshooting.

It is, however, our opinion that taking such an approach would limit the appeal of the system to a wider user base. This opinion is 
driven by several considerations:

* The cloud computing market segment enjoys a great deal of growth and significant shifts in growth year-over-year, thus committing 
  to a particular platform that is seen as a current market leader today, may limit the usability of the software when the chosen vendor 
  falls out of the race in the future.
* Because the market segment is highly competitive, end users can benefit significantly from limited time deals offered to them 
  by cloud providers if they are flexible about what platform to deploy on.
* Selecting one vendor induces vendor lock-in, possibly forcing adoption of inferior technologies to stay consistent with vendor choice.
* Public and Private clouds typically operate on different software stacks. The nature of the data that is subject to scientific 
  analysis may dictate where the analysis is able to proceed. 

On the other hand, supporting multiple cloud vendors has its own set of drawbacks:

* Handling multiple APIs for different vendors increases system complexity.
* A solution that is vendor agnostic may lack certain capabilities that are only available to a subset of the vendors.
* Some code duplication is inevitable when dealing with multiple platforms.

Based on considerations above we have taken the path of creating a cloud-agnostic system, i.e. one that will run on any major cloud providers, 
public, or private.

Open Source License
'''''''''''''''''''
We adopt an open-source GPL v3.0 license for Butler.


Overall System Design
'''''''''''''''''''''

Overall, the Butler system can be thought of as being composed of four distinct sub-systems:

* **Cluster Lifecycle Management** - This sub-system deals with the task of creating and tearing down clusters on various clouds, including 
  defining Virtual Machines, storage devices, network topology, and network security rules.
* **Cluster Configuration Management** - This sub-system deals with configuration and software installation of all VMs in the cluster.
* **Workflow System** - The Workflow sub-system is responsible for allowing users to define and run scientific workflows on the cloud.
* **Operational Management** - This sub-system provides tools for ensuring continuous successful operation of the cluster, as well as 
  for troubleshooting error conditions.

Each sub-system is described in full detail below.

Cluster Lifecycle Management
````````````````````````````

Before any computation can happen on the cloud a cluster of Virtual Machines is needed. The scope of Cluster Lifecycle Management includes:

* Defining hardware configuration for VMs
* Defining initial basic software configuration for VMs
* Defining storage devices
* Defining network topology
* Defining network security
* Creating and Tearing down VMs

To fulfill these requirements in a cloud agnostic manner Butler utilizes a framework called Terraform, developed by Hashicorp.

Terraform
'''''''''

Terraform is an Open Source framework for cloud agnostic cluster lifecycle management, that has been built by Hashicorp Inc., a San Francisco, 
California based company, and is distributed via a Mozilla Public License. The source code for Terraform is hosted on Github at 
://github.com/hashicorp/terraform, and at the time of this writing (September, 2016) the latest release of the software is version v0.7.3

Terraform uses a proprietary human and machine readable file format for specifying cluster configurations that is called HashiCorp Configuration 
Language (HCL). Using this language the end user can define a number of constructs for cluster management, most important among them are - 
providers, resources, and variables.

Terraform Providers
...................

Terraform providers enable the framework to talk to different cloud provider APIs. Each provider is responsible for translating HCL configurations 
into cloud-specific API calls. At the time of this writing the following Providers are available:

* AWS
* CenturyLinkCloud
* CloudFlare
* CloudStack
* Cobbler
* Datadog
* DigitalOcean
* DNSimple
* Google Cloud
* Heroku
* Microsoft Azure
* OpenStack
* SoftLayer
* Scaleway
* Triton
* VMware vCloud Director
* VMware vSphere

Typically in order to use a particular provider the user needs to insert a provider block into their configuration file where they specify details 
relevant to communicating with the particular API in question, such as - endpoint URL, username, password, SSH keyname, API key, etc., as seen here (for AWS):

.. code-block:: yaml

	provider "aws" {
	  access_key = "${var.aws_access_key}"
	  secret_key = "${var.aws_secret_key}"
	  region     = "us-east-1"
	}

Once the user has specified a provider they can declare provider-specific Resources that define their cluster.

Terraform Resources
...................

Resources represent different objects such as VMs, network routers, security groups, disks, etc., that the user can create on a given cloud. 
Each resource has a set of configuration options that can be specified to customize its behaviour. An optional *count* attribute defines how many 
instances of the resource need to be created in the cluster.

.. code-block:: yaml

	resource "aws_instance" "salt_master" {
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
	}

Most Terraform configuration involves configuring resources.

Terraform Variables
...................

Terraform variables are similar to variables in any other programming context. They consist of values assigned to labels, that can then be used for 
lookup elsewhere. Variables can be of string, list, or map type.

.. code-block:: yaml

	variable "username" {
		default="centos"
	}
	
	variable "worker_count" {
		default="1"
	}
	
	variable "aws_amis" {
	  default = {
	    eu-central-1 = "ami-9bf712f4"
	  }
	}
	
Users typically specify variables in a separate configuration file and then use them throughout their cluster definition. 

One special case of using variables comes from specifying secret values such as passwords or secret keys that the use would not want to commit to a 
source repository. In this case, a variable can be referred to inside the configuration file, while being defined as an environment variable on the 
machine that Terraform will be executed on. The user prefixes the variable name with a special prefix - TF_VAR which signals Terraform to parse the
environment variable as a Terraform variable and allow appropriate substitution at runtime.

Terraform Provisioners
......................

When a Virtual Machine is created the user may want to place certain files on it or run certain commands such as starting services or registering with 
a cluster manager, in order to bootstrap it. This purpose is served by Terraform Provisioners, which define code blocks that are executed on the target 
resource upon creation.

.. code-block:: yaml

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
	
Terraform Installation
......................

Terraform is installed via a binary file downloaded from the Hashicorp website or by compiling the source code from github. It is a lightweight application 
that can be run from either the user's local machine, or from a special host on the target cloud environment. The application consists of a terraform CLI 
that the user can interact with by issuing shell commands. Typically users will combine their Terraform configuration files (stored in a source code repository) 
with a set of locally defined environment variables to set up and manage their clusters via the CLI.

Terraform Cluster Lifecycle
...........................

The key task of Terraform is to perform Create, Read, Update, and Delete on cluster resources. Create and Update operations are accomplished by issuing a 
:code:`terraform apply` command at the shell, while the shell is pointing to a directory with Terraform resource definitions. If the resources specified in the 
configuration do not yet exist, they are created. If the resource definitions have been changed since the last time :code:`terraform apply` was run, they will be 
brought into a state consistent with the latest definitions. This may involve updating existing resources where possible, or recreating them, where an update is not 
possible.

Terraform determines what changes need to be made in order to perform a successful Update via a file that is called a State file. This file specifies in a JSON 
ormat the current state of all infrastructure managed by Terraform. Running :code:`terraform apply` causes the tool to inspect current state and compare it to the 
target state, issuing any necessary commands to update current state to the target.

The Read operation simply displays the current Terraform state file via the :code:`terraform show` command.

The Delete operation is accomplished via the  :code:`terraform destroy` command.

Other commands allow the user to validate the syntax of their configuration files, perform a dry run of resource creation, manually mark resources for recreation, 
and others.


	

