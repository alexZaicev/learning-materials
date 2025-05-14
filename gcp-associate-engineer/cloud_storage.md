## Storage

### Block storage

**Block storage or Persistence disk** are network-attached block storage devices that can be used with VMs and provide
storage for instances running on GCE and GKE.

#### Key features

- **Highly durable and available**: by design block storage is highly durable and data is replicated within its zone
  protecting from hardware failure.
- **Variety of options**: HDD for moderate IO/sec (IOPS) and SSD for high-IOPS;
- **Scalable**: block storage can scale up to 64TB and dynamically resized without any downtime.
- **Encryption**: each disk is encrypted with key that are managed by Cloud KMS.
- **Snapshots**: snapshots can be created for backups and restore.
- **Shaped persistent disks**: read-only or read-write disks can be connected simultaneously to multiple VMs that makes
  it useful for parallel processing or clustered software.

#### Options

| Block Storage Option               | Description                                                                                             | Best for                                                                                  |
|------------------------------------|---------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| **Standard Persistent Disk (HDD)** | Cost-effective block storage suitable for moderate IOPS.                                                | Large sequential read/write operations, such as file servers and data warehousing.        |
| **SSD Persistent Disk**            | Suitable for high-IOPS applications. Provides low latency.                                              | High-speed random I/O access scenarios like high-performance databases and boot disks.    |
| **Local SSDs**                     | Physically attached to the VM's host server for high IOPS and very low latency.                         | Temporary storage like scratch disks, cache, or data replicated across multiple machines. |
| **Regional Persistent Disks**      | Allows the disk to be synchronously replicated between two zones in the same region.                    | High-availability or high-value databases that quickly read and write to a single disk.   |
| **RAM Disks**                      | Uses the instance's system memory for storage and provides high IOPS, low latency, and high throughput. | Applications which require frequent reads and writes to temporary storage.                |…

#### Snapshots and machine images

|                      | Snapshot                                    | Machine Image                                                                          |
|----------------------|---------------------------------------------|----------------------------------------------------------------------------------------|
| **What it captures** | Just the disk data.                         | The entire virtual machine (Both disk data and configuration).                         |
| **Usage**            | For backups, can be used to restore a disk. | For backups, replication, or migration. Can be used to create new, matching instances. |
| **Scope**            | Can be used across projects and regions.    | Can be used across projects and regions.                                               |

### File storage

**File storage or Cloud Filestore** is a manage file storage service for applications that require a traditional file
system interface and a shared file system. Provides simple native experience for managed NAS.

#### Key features

- **High performance**: based on the service tier, provides high IOPS and throughput, specifically for applications
  requiring high-speed file-based workload.
- **Fully managed**: Google Cloud managed the underlying infrastructure, including hading the setup of file systems,
  capacity planning, hardware and software tuning etc.
- **Network Attached Storage (NAS)**: filestore instances are available across the entire network, making it easier to
  manage files centrally in applications with distributed microservices architectures.
- **Compatibility**: filestore uses standard NFS protocol, meaning that applications running on virtually any OS can use
  it.
- **Backups and restore**: secure backup and restore of filestore instances.

#### Options

| Filestore Option   | Description                                                                              | Best for                                                                                           |
|--------------------|------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| **Basic HDD**      | Economical performance tier for light workloads. Throughput limit of 12 MB/s per TB.     | Applications with moderate file storage requirements that do not have high IOPS/throughput needs.  |
| **High Scale SSD** | Designed for high-performance computing workloads. Up to 1.2 GB/s per TiB of throughput. | High-performance applications, large databases, and intensive data processing tasks.               |
| **Enterprise SSD** | Highest performance and availability, lowest latency and highest IOPS.                   | Most demanding enterprise applications that require high IOPS, low latency, and high availability. |

### Object storage

**Object storage or Cloud Storage** is the service allowing to store and retrieve any type of data as objects. Objects
are stored in bucket containers that can follow a hierarchical folder structure that provide expanded access to groups
of objects with a shared name prefix.

#### Key features

- **Scalability**: Cloud storage is design to scale based on the request demand, meaning in can handle large amount of
  data ad high request rates.
- **Durability and availability**: offers high durability and availability of data, by automatically replicating data
  across multiple geographical dispersed regions.
- **Security**: Cloud storage provides strong security features with multiple layers of security to protect data
  including encryption at rest and in transit, IAM controls, and audit logs.
- **Versioning**: objects stored in Cloud storage can be versioned and retained as a non-current version. This is useful
  in case an object was deleted accidentally, it can be restored from the version.
- **Lifecycle**: Cloud storage supports object lifecycle configurations, providing a mechanism to automatically perform
  an action on an object after a certain time period have past, e.g. archive or delete an object after a month.

#### Storage classes

| Storage Class | Use Case                                                        | Minimum Storage Duration |
|---------------|-----------------------------------------------------------------|--------------------------|
| Standard      | Frequently accessed data, data stored for short periods of time | N/A                      |
| Nearline      | Infrequent access, backups, long-tail multimedia content        | 30 days                  |
| Coldline      | Very infrequent access, disaster recovery                       | 90 days                  |
| Archive       | Long-term archiving, data accessed less than once a year        | 365 days                 |

#### Service level agreement (SLA):

| Covered Service                                                                                                                                                         | Monthly Uptime Percentage |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|
| Standard storage class in a multi-region or dual-region location of Cloud Storage                                                                                       | >= 99.95%                 |
| Standard storage class in a regional location of Cloud Storage; Nearline, Coldline, or Archive storage class in a multi-region or dual-region location of Cloud Storage | >= 99.99%                 |
| Nearline, Coldline, or Archive storage class in a regional location of Cloud Storage; Durable Reduced Availability storage class in any location of Cloud Storage       | >= 99.0%                  |

The turbo replication feature will provide the following Service Level Objectives:

| Covered Service                                                                                                  | Monthly Uptime Percentage                                                                          |
|------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| Any Cloud Storage bucket for which the turbo replication feature has been activated for the entire billing month | Monthly Replication Time Conformance >= 99.0% <br/>Monthly Replication Volume Conformance >= 99.9% |

#### Upload/download methods:

| Method              | Use Case                                                                              |
|---------------------|---------------------------------------------------------------------------------------|
| Simple Upload       | Small files or files that need specific metadata. Typically done in a single request. |
| Multipart Upload    | Larger files, allows uploading parts in parallel and recovers from network issues.    |
| Resumable Upload    | Large files and when you're uploading over an unreliable network.                     |
| Downloading Objects | Done via storage client library or HTTP/HTTPS using object's `mediaLink`.             |
| Streaming Transfers | Uploading or downloading only the bytes that you want or need.                        |

#### Uniform bucket-level access (UBLA)

**Uniform bucket-level access** is a feature allowing to manage bucket and object access. Instead of managing access
control on each object individually, UBLA simplifies access management by enabling bucket-level access management.

When enabled, Access Control Lists (ACLs) are disabled for all objects in the bucket. All newly created objects in the
bucket will inherit the bucket's Identity and Access Management (IAM) policy, and you won't be able to grant access to
objects using ACLs.
