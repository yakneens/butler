|health| |docs| |gitter|

.. |build-status| image:: https://img.shields.io/travis/rtfd/readthedocs.org.svg?style=flat
    :alt: build status
    :scale: 100%
    :target: https://travis-ci.org/rtfd/readthedocs.org

.. |docs| image:: https://readthedocs.org/projects/butler/badge/?version=latest
    :alt: Documentation Status
    :scale: 100%
    :target: http://butler.readthedocs.io/en/latest/?badge=latest
    
.. |health| image:: https://landscape.io/github/llevar/butler/master/landscape.svg?style=flat
	:target: https://landscape.io/github/llevar/butler/master
	:alt: Code Health
   
.. |coverage| image:: https://coveralls.io/repos/github/llevar/butler/badge.svg?branch=master
	:target: https://coveralls.io/github/llevar/butler?branch=master

.. |gitter| image:: https://badges.gitter.im/butler-cloud/Lobby.svg
   	:alt: Join the chat at https://gitter.im/butler-cloud/Lobby
   	:target: https://gitter.im/butler-cloud/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge

.. image:: docs/images/butler_logo_with_text.png
 
.. docs-include-start-marker

 .. image:: images/butler_logo_with_text.png
 
############################################################
A Framework for large-scale scientific analysis on the cloud
############################################################


.. _Terraform: http://terraform.io
.. _Saltstack: https://saltstack.com/
.. _Apache Airflow: https://airflow.incubator.apache.org/
.. _Grafana: https://grafana.com/
.. _Influxdb: https://www.influxdata.com/
.. _PostgreSQL: https://www.postgresql.org/
.. _Celery: http://www.celeryproject.org/
.. _Elasticsearch: https://www.elastic.co/
.. _Consul: https://www.consul.io
.. _CWL: http://www.commonwl.org/
.. _BWA: http://bio-bwa.sourceforge.net/
.. _freebayes: https://github.com/ekg/freebayes
.. _Pindel: http://gmt.genome.wustl.edu/packages/pindel/
.. _Delly: https://github.com/dellytools/delly
.. _R: https://cran.r-project.org/
.. _Documentation: http://butler.readthedocs.io
.. _PCAWG: https://dcc.icgc.org/pcawg
.. _EOSC: http://eoscpilot.eu/
.. _source repository: https://github.com/llevar/butler
.. _keynote: https://youtu.be/n5W3p3hN_bQ
.. _paper: https://www.nature.com/articles/s41587-019-0360-3

===============
What is Butler?
===============

Butler is a collection of tools whose goal is to aid researchers in carrying out scientific analyses on a multitude of cloud computing platforms (AWS, Openstack, Google Compute Platform, Azure, and others). 
Butler is based on many other Open Source projects such as - `Apache Airflow`_, Terraform_, Saltstack_, Grafana_, InfluxDB_, PostgreSQL_, Celery_, Elasticsearch_, Consul_, and others. 

Butler aims to be a *comprehensive* toolkit for analysing scientific data on clouds. To achieve this goal it provides functionality in four broad areas:

* **Provisioning** - Creation and teardown of clusters of Virtual Machines on various clouds.
* **Configuration Management** - Installation and configuration of software on Virtual Machines.
* **Workflow Management** - Definition and execution of distributed scientific workflows at scale.
* **Operations Management** - A set of tools for maintaining operational control of the virtualized environment as it performs work.

You can use Butler to create and execute workflows of arbitrary complexity using Python, or you can quickly wrap and execute tools that ship as Docker containers, or are described with the 
Common Workflow Language (CWL_). Butler ships with a number of ready-made workflows that have been developed in the context of large-scale cancer genomics, including:

* Genome Alignment using BWA_ 
* Germline and Somatic SNV detection and genotyping using freebayes_, Pindel_, and other tools
* Germline and Somatic SV detection and genotyping using Delly_
* Variant filtering
* R_ data analysis

A typical Butler deployment looks like this:

.. image:: docs/images/embassy_butler_deployment_architecture.png

It can look like a bit of a tangle but is actually fairly simple: The Salt Master configures and installs software, 
the Tracker schedules workflows and puts them into a RabbitMQ queue keeping track of their state in a database, 
a fleet of Workers pick up workflow tasks and execute them, the Monitoring Server harvests logs and metrics
from everything and visualizes them on graphical dashboards. That's about it. Many more details about how
everything works can be found in the Documentation_.



================
Who uses Butler?
================

* The **Pan Cancer Analysis of Whole Genomes Project** (PCAWG_) - used Butler to run cancer genomics workflows on 2800+ high-coverage whole genome samples (725 TB of data) on Openstack.
* The **European Open Science Cloud Pilot Project** (EOSC_) - using Butler to run cancer genomics workflows on multiple platforms (Openstack, AWS).
* The **Pan Prostate Cancer Group** - using Butler to run cancer genomics workflows on 2000+ whole genome prostate cancer samples on Openstack. 

===============
Getting Started
===============

To get started with Butler you need the following:

* A target cloud computing environment.
* Some data.
* An analysis you want to perform (programs, scripts, etc.).
* The Butler `source repository`_.

The general sequence of steps you will use with Butler is as follows:

* Install Terraform_ on your local machine
* Clone the Butler Github repository
* Populate cloud provider credentials
* Select deployment parameters (VM flavours, networking and security settings, number of workers, etc.)
* Deploy Butler cluster onto your cloud provider
* Use Saltstack_ to configure and deploy all of the necessary software that is used by Butler (this is highly automated)
* Register some workflows with your Butler deployment
* Register and configure an analysis (what workflow do you want to run on what data)
* Launch your analysis
* Monitor the progress of the analysis and the health of your infrastructure using a variety of dashboards

.. docs-include-end-marker

==========
Next Steps
==========
Head over to the Documentation_ to learn about how to use Butler for your project.

Watch the keynote_ presentation by Sergei Yakneen from the de.NBI Cloud Computing Summer School in Giessen, Germany, from June 2017 that describes Butler.

Read the Butler paper_ in Nature Biotechnology.

.. image:: docs/images/de.NBI_Bild.png
   :scale: 20%


