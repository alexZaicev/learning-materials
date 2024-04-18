## Google Compute Engine (GCE)

### What is GCE?

Compute engine is an IaaS product offering flexible, self-managed VMs hosted on Google's infrastructure. It includes
Linux and Windows based VMs running on Kernel-based virtual machine (KVM), local and durable storage options, and a REST
API for configuration and control.

Features:

- Create and manage VM instance lifecycle
- Load balancing and auto-scaling of the VM instances
- Network connectivity and configuration management of the VM instances
- Automatic basic monitoring such CPU utilization, network bytes (in/out), disk throughput/IOPS
- Sole-tenancy allows customer to own a specific node for their enterprise workloads

### What machine types are available?

GCE provides a number of different machines families for various workloads:

- **General purpose** (E2, N2, N2D, N1): Best price-performance ratio that are suitable for web and application servers,
  small/medium databases etc.
- **Memory optimized** (M2, M1): Ultra high memory workloads, suitable for large in-memory databases and in-memory
  analytics.
- **Compute optimized** (C2): Compute intensive workloads, suitable for gaming applications.

Each machine family offers a number of machine types that differs by the number of CPU and RAM they provide.

### What OS images are available?

- **Public images** - provided & maintained by Google or OS communities or 3rd party vendors.
- **Custom image** - created and maintained by the user.

### What IP addresses are available?

- **Internal** - cannot be reached from the internet and are not publicly routable.
- **External** - publicly advertised, meaning they are reachable by any host on the internet.They can be ephemeral (
  released if not used) or static (retained).

### How to simplify VM creation?

#### Startup scripts

A startup script is a file that contains commands that run when a virtual machine (VM) instance boots. Compute Engine
provides support for running startup scripts on Linux VMs and Windows VMs.

Benefits of using _setup scripts_:

- **Automation**: Setup scripts automate the process of configuring VM instances, which saves time and reduces the risk
  of human error. You can define the desired state of your VM environment in the script, and GCP will execute it during
  VM provisioning.
- **Consistency**: Setup scripts ensure consistency across your VM instances. By defining the configuration in a script,
  you can easily replicate the setup across multiple VMs, ensuring they all have the same software packages,
  configurations, and dependencies.
- **Scalability**: With setup scripts, you can easily scale your infrastructure by provisioning new VM instances with
  the same configuration as existing ones. This is particularly useful in scenarios where you need to quickly deploy
  additional resources to handle increased workload or traffic.
- **Customization**: Setup scripts allow you to tailor the VM environment to your specific requirements. You can install
  custom software packages, configure network settings, set up users and permissions, and perform any other necessary
  tasks to meet your application's needs.
- **Version Control**: Setup scripts can be version-controlled using tools like Git, allowing you to track changes over
  time and revert to previous configurations if needed. This helps in maintaining the integrity of your infrastructure
  and facilitates collaboration among team members.
- **Reproducibility**: By encapsulating the configuration in a script, you can easily reproduce the same environment in
  different regions or environments (e.g., development, staging, production). This simplifies testing and
  troubleshooting and ensures consistent behavior across different deployment environments.
- **Documentation**: Setup scripts serve as documentation for your VM configuration. Anyone with access to the script
  can understand how the VM is set up and make modifications as necessary, improving overall system maintainability.

#### Instance templates

Instance templates are a convenient way of saving VMs configuration, including machine type, boot disk, image, labels
etc. The benefits of using instance templates are:

- **Standardization**: Instance templates allow you to define a standard configuration for VM instances, including
  machine type, boot disk image, networking settings, and metadata. This ensures consistency across your infrastructure
  and reduces the risk of configuration errors.
- **Reusability**: Once you create an instance template, you can use it to create multiple VM instances with the same
  configuration. This saves time and effort, especially when provisioning large numbers of instances for scaling
  purposes or creating identical environments for testing and development.
- **Versioning**: Instance templates support versioning, allowing you to update and manage different versions of the
  template. This enables you to make changes to the template configuration without affecting existing VM instances and
  provides a way to roll back to previous versions if needed.
- **Flexibility**: Instance templates support parameterization, allowing you to define variables that can be customized
  when creating VM instances. This flexibility enables you to create instances with variations in configuration while
  still maintaining a standardized template.
- **Scalability**: Instance templates are well-suited for autoscaling scenarios, where VM instances are dynamically
  created or terminated based on demand. By defining autoscaling policies that reference instance templates, you can
  easily scale your infrastructure up or down to handle fluctuations in workload or traffic.
- **Integration with Managed Instance Groups**: Instance templates are commonly used in conjunction with managed
  instance groups (MIGs), which are used for autoscaling and load balancing. MIGs reference instance templates to create
  and manage a group of VM instances, automatically scaling them based on predefined criteria.
- **Simplified Management**: Using instance templates simplifies the management of VM instances by centralizing
  configuration settings in a single template. This makes it easier to update and maintain the configuration of multiple
  instances simultaneously, reducing administrative overhead.
- **Infrastructure as Code (IaC) Integration**: Instance templates can be managed programmatically using Infrastructure
  as Code (IaC) tools like Terraform or Deployment Manager. This enables you to define your infrastructure configuration
  in code, version-control it, and automate the provisioning and management of VM instances.

#### Custom images

The startup scripts and instance templates are great solutions to automate the creation of the VM instances, however,
they do come with the increase boot up time due to all the configuration that is happening. To create an instance with
already available security patches, hardening etc., a custom image can be created.

The custom image can be created from an instance, a persistent disk, a snapshot, another image, or a file in Cloud
Storage.

The benefits of using _custom images_:

- **Preconfigured Environment**: Custom images allow you to create VM instances with a preconfigured operating system,
  software packages, configurations, and data. This ensures that your instances are set up exactly as needed, saving
  time and effort compared to manual configuration.
- **Consistency**: Custom images help maintain consistency across your infrastructure by ensuring that all VM instances
  are created from the same baseline configuration. This reduces the risk of configuration drift and ensures that your
  applications behave predictably across different instances.
- **Security**: Custom images can include security configurations, patches, and updates tailored to your organization's
  requirements. By starting with a hardened image, you can reduce the attack surface and mitigate security risks
  compared to using unpatched or insecure default images.
- **Performance Optimization**: Custom images can be optimized for performance by including optimized settings, drivers,
  and configurations specific to your workload. This can lead to improved application performance and efficiency,
  especially for compute-intensive or resource-constrained applications.
- **Version Control**: Custom images can be versioned and managed using tools like Google Cloud Storage or Compute
  Engine's image versioning feature. This allows you to track changes over time, roll back to previous versions if
  needed, and ensure that all instances are running the latest approved image version.
- **Compliance**: Custom images can be configured to comply with regulatory requirements and organizational policies,
  such as data sovereignty, encryption standards, or industry-specific regulations. By starting with a compliant image,
  you can streamline the process of meeting compliance obligations for your infrastructure.
- **Customization**: Custom images provide flexibility to customize the operating system and software stack to meet the
  specific needs of your applications. You can install additional software, configure services, and customize settings
  to match your requirements without relying on predefined images or configurations.
- **Offline Usage**: Custom images can be exported and used offline, allowing you to create VM instances in environments
  without direct internet access or in air-gapped environments. This can be useful for scenarios where internet
  connectivity is limited or restricted.

### What are sustained use discounts?

The **sustained use discounts** are applied to VM instances for a significant portion of the billing month. The
discount is based on the total amount of time VM instances are used in a month.

**How it Works**: As VM instances are used for more hours in a month, the per-hour cost decreases. Google Cloud
automatically calculates and applies the discount based on usage, so you don't need to take any action to receive the
discount.

**Benefits**: Sustained use discounts provide cost savings for workloads that require consistent, long-term usage of VM
instances. The discount is applied automatically without the need for upfront commitments.

### What are committed use discounts?

The **committed use discounts** are received after committing to a specific amount of usage for VM instances over a term
of 1-3 years.

**How it Works**: You commit to a specific amount of usage (measured in vCPU and memory) for VM instances over a 1 or
3-year term. In return, you receive discounted prices compared to the pay-as-you-go rates. The discount applies
regardless of actual usage, so you benefit even if your usage fluctuates.

**Benefits**: Committed use discounts offer significant cost savings for predictable workloads with steady or growing
usage over time. By committing to usage upfront, you lock in discounted prices, which can result in lower overall costs
compared to pay-as-you-go pricing.

### What are preemptible VM instances?

Preemptible VM instance is special type of instance that is designed to be short-lived, meaning that GCP can shut it
down with a 30-seconds warning to reclaim the compute power for other workloads. They are available ar a lower cost (
60-91% discount).

| Pros                                                                                                                                                                                                 | Cons                                                                                                                                                                                                                                                                                     |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Cost Savings**: Preemptible VMs are significantly cheaper than regular VMs, often up to 80% less expensive. This makes them a cost-effective option for workloads that can tolerate interruptions. | **Limited Availability**: Preemptible VMs can be interrupted by Google Cloud at any time, typically with a 30-second notice. This makes them unsuitable for mission-critical or long-running workloads that cannot tolerate interruptions.                                               |
| **Flexibility**: Preemptible VMs are ideal for batch processing, parallel processing, and other short-lived, non-critical workloads where flexibility is more important than uptime.                 | **Limited Lifespan**: Preemptible VMs have a maximum lifespan of 24 hours, after which they are automatically terminated by Google Cloud. This limits their suitability for workloads that require continuous, uninterrupted operation.                                                  |
| **Scalability**: Preemptible VMs can be used to scale out workloads quickly and cost-effectively, allowing you to increase compute capacity during peak demand periods without breaking the bank.    | **No SLA**: Google Cloud does not provide any Service Level Agreement (SLA) for preemptible VMs, which means there is no guaranteed uptime or availability.                                                                                                                              |
| **No Long-Term Commitments**: Unlike committed use discounts, preemptible VMs do not require long-term commitments, allowing you to use them on a pay-as-you-go basis without upfront commitments.   | **Resource Constraints**: Preemptible VMs may have resource constraints, such as limited availability of certain machine types or regions, which can restrict their usability for some workloads.                                                                                        |
| **Use Cases**: Preemptible VMs are suitable for various use cases such as data analytics, batch processing, rendering, testing, and development environments.                                        | **Data Persistence**: Preemptible VMs do not guarantee data persistence, as any data stored on the local disk is lost when the VM is preempted. You need to design your applications to store data externally, such as in Google Cloud Storage or a database, to ensure data durability. |

### What are spot VM instances?

Spot VM instances are very similar to preemptible VM instances with a key difference of not having minimum and maximum
runtime unless you specifically limit the runtime.

### What are live migrations and availability policies?

**_Live migration_** is a feature that allows GCE to automatically move a running VM instance from one physical host to
another host within the same zone without causing any noticeable downtime or impact on the VM's availability. This helps
to ensure high availability and reliability for workloads running on GCE.

**_Availability policy_** provides an ability to specify preferences and requirements for the distribution of VM
instances across different zones withing the same region to improve availability and fault-tolerance.


### What are instance groups?

An instance group is a logical grouping of VM instances that are managed and treated as a single entity. All instances
withing a group share the same configuration (machine type, image, networking etc.).

Types:

- **Managed instance groups (MIGs)**: Managed instance groups are used for autoscaling and load balancing based on the
  incoming traffic load or other criteria, ensuring optimal performance and resource utilization. MIGs usually are
  created with instance templates ensuring consistency during instance creation.
  Additional features:
    - Health checking: MIGs provide an ability to specify health probe to validate the state of the working instance;
      unhealthy instances get replaced or removed from the group to maintain reliability.
    - Rolling updates: MIGs provide an ability to perform rolling updates ensuring no downtime during instance update.
      MIGs also support canary deployments, allowing to gradually test new versions and rollout the update.
    - Regional and zonal groups: instance groups can be configured to space multiple zones within a region or be
      configured to a single zone, depending on the required availability and fault-tolerance.
- **Unmanaged instance groups**: Unmanaged instance groups are collections of instances that are managed by the user
  manually without auto-scaling or load-balancing features and are primarily used for specialized or legacy workloads
  requiring manual management.

> CLI command: `gcloud compute instance-groups manage ...`

> NOTE: When performing rolling updates/restarts you can specify the maximum number of unavailable instances to maintain
> the same capacity (CLI option `--max-unavailable`), and you can also specify the maximum number of additional instance
> created during the action (CLI option `--max-surge`).
