## Managed Services

**Infrastructure as a Service (IaaS)**: is a cloud computing model where virtualized computing resources, including
virtual machines, storage, and networking components, are provided over the internet as scalable and on-demand services.
In IaaS, users have access to a flexible and customizable infrastructure without the need to invest in or manage
physical hardware. They can dynamically allocate and manage computing resources based on their requirements, scaling up
or down as needed to accommodate fluctuating workloads. IaaS providers handle the maintenance and management of the
underlying infrastructure, allowing users to focus on developing and deploying applications without the burden of
infrastructure management.

Example: GCE virtual machines

**Platform as a Service (PaaS)**:  is a cloud computing model that provides a platform allowing customers to develop,
run, and manage applications without the complexity of building and maintaining the underlying infrastructure. In PaaS,
users have access to a complete development and deployment environment, including tools, middleware, runtime, and
operating system, hosted on the cloud provider's infrastructure. PaaS enables developers to focus on writing and
deploying code, rather than managing servers and infrastructure. It abstracts away the underlying complexities of
infrastructure management, offering a streamlined and scalable platform for building and deploying applications rapidly.

Example: Container as a Service, Function as a Service, Serverless etc.

![Cloud solutions](https://lh3.googleusercontent.com/Zpw-v4ZOiAkbLm9ARSl68tGaZFYsFsz1ABwRbl8Cj_ozj12jCTPmgVGKBARz3Xwum1CUsMQ7Hog=e14-rj-sc0xffffff-h2000-w2000)

### Cloud APP Engine

**Cloud app engine** - is a fully managed, serverless platform for developing and hosting web applications at scale,
providing support for a variety of programming languages, libraries, and frameworks to developers. App engine take care
of provisioning servers and scaling application instances on demand.

#### Key Features

- **No server management**: deploy your code and app engine automatically manages the servers to keep the applications
  highly available.
- **Automatic scaling**: depending on demand, app engine can automatically adjust the number of running application
  instances.
- **Support for multiple languages**: supports a broad range of popular programming languages, such as Go, Java, Python.
- **Integrated services**: easy integration with other GCP services, such as Cloud SQL, Cloud Storage etc.
- **Traffic splitting and release management**: app engine allow you to manage your application releases by splitting
  traffic amongst different versions of your app, enabling canary releases, A/V testing etc.
- **Security**: build-in protections to defend against DDoS attacks, provides SSL/TLS certificates for custom domains,
  and allows for custom firewall rules to control traffic.
- **Diagnostics and monitoring**: integration with Cloud Logging and Cloud Monitoring for gaining insights into the
  performance and overall health of the application.

#### Variants

Cloud app engine provides two variants, standard and flexible, with the following differences:

|             | Standard                                                                                                                                                     | Flexible                                                                                                                                                                                                            |
|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Runtime     | Provides various pre-defined runtime environments (NodeJs, Go etc.). The runtimes are sandboxed, and they've specific limitations for a faster boot up time. | Provides more freedom by allowing developers to choose any runtime environment that can be a containerized with a custom Dockerfile. It's not sandboxed, thus provides more flexibility, but a longer startup time. |
| Scalability | Automatically scales the application up and down to 0 based on the incoming traffic. Supports manual, basic, and automatic scaling                           | Offers auto-scaling, however, instances are running continuously, even when idle. Supports manual and automatic                                                                                                     |
| Networking  | Supports only HTTP/HTTPS traffic                                                                                                                             | No limitations, meaning even SSH can be used for debugging                                                                                                                                                          |
| Disk access | Access only to Cloud Storage                                                                                                                                 | Supports writable disk storage                                                                                                                                                                                      |
| Cost        | Cost-effective solution for applications with variable traffic that can utilize automatic scaling. Cost if calculated based on the execution time.           | Costs more than the standard option, however with the benefit of more flexibility and ensuring 1 resource is always up. Cost is calculated by the resource utilization, such as vCPU, Memory etc.                   |

#### Component Hierarchy

<img src="https://cloud.google.com/static/appengine/docs/legacy/images/modules_hierarchy.svg" alt="Component hierarchy" style="background: whitesmoke">

1. **Application**: Each Google Cloud project has exactly one App Engine application allowing to manage all the
   resources in a centralized manner. Each application hosts multiple services and versions.
2. **Service**: A service in the App Engine is a collection of specific instances of the application, e.g. frontend and
   backend, or a single microservice.
3. **Version**: Each service allows multiple versions, proving the flexibility to deploy updated code or add new
   features without affecting current application. Service allows to have different versions that are access via
   different URLs.
4. **Instance**: Is a single, lightweight computing unit in App Engine that used one web-server to respond to incoming
   requests. App engine itself decides when to scale up/down and how to manage incoming traffic between multiple
   instances.

#### App Engine configuration files

The `app.yaml` is the main service configuration file with the following content:

```yaml
runtime: python39 # Indicates the runtime to use
api_version: 1.0 # Specifies the runtime API version
service: service-name # Defines the service name

env: flex # Defines whether to deploy the service to flexible environment

instance_class: F1 # Defines the instance class.

resources:
  cpu: 1 # Number of CPU units for the instance.
  memory_gb: 0.5 # The amount of memory for the instance.
  disk_size_gb: 1 # The disk size for each instance. 

env_variables: # Environmental variables
  VAR1: "something"
  VAR2: "something_else"

automatic_scaling: # Automatic scaling block
  target_cpu_utilization: 0.65
  min_instances: 1
  max_instances: 100
  min_idle_instances: automatic
  max_idle_instances: automatic
  min_pending_latency: automatic
  max_pending_latency: 30ms
  max_concurrent_requests: 50

basic_scaling: # Basic scaling block
  max_instances: 1
  idle_timeout: 10m

manual_scaling: # Manual scaling block
  instances: 5

entrypoint: 'python main.py'

beta_settings: # Optional block for beta settings
  cloud_sql_instances: "project:region:sql-instance"

network: # Network settings block
  instance_tag: "tag"
  name: "network"

vpc_access_connector: # VPC access settings block
  name: "projects/PROJECT_ID/locations/REGION/connectors/CONNECTOR_NAME"

# Defines handlers.
handlers:
  - url: /static
    static_dir: static/
  - url: /.*
    script: auto
```

The `dispatch.yaml` is used for routing rules and traffic splitting across different services within the app engine:

```yaml
dispatch:
  # Default service serves the typical web resources and all static resources.
  - url: "*/favicon.ico"
    service: default

  # Default service serves simple hostname request.
  - url: "simple-sample.uc.r.appspot.com/"
    service: default

  # Send all mobile traffic to the mobile frontend.
  - url: "*/mobile/*"
    service: mobile-frontend

  # Send all work to the one static backend.
  - url: "*/work/*"
    service: static-backend
 ```

The `queue.yaml` is used to define the properties of task queues in the application, allowing for the named queue
declarations control of rates, bucket sizes, etc.:

```yaml
queue:
  - name: fooqueue
    rate: 1/s
    retry_parameters:
      task_retry_limit: 7
      task_age_limit: 2d
  - name: barqueue
    rate: 1/s
    retry_parameters:
      min_backoff_seconds: 10
      max_backoff_seconds: 200
      max_doublings: 0
  - name: bazqueue
    rate: 1/s
    retry_parameters:
      min_backoff_seconds: 10
      max_backoff_seconds: 200
      max_doublings: 3
```

The `cron.yaml` is used to schedule regular, automated task that can operate at different times:

```yaml
cron:
  - description: "daily summary job"
    url: /tasks/summary
    schedule: every 24 hours
  - description: "monday morning mailout"
    url: /mail/weekly
    schedule: every monday 09:00
    timezone: Australia/NSW
  - description: "new daily summary job"
    url: /tasks/summary
    schedule: every 24 hours
    target: beta
```

#### Request routing

With the App engine request routing can be handled with the following combinations:

- **Dispatch files**: App engine supports dispatch files for routing definitions
- **Service and version (URLs)**: For accessing a specific service or version you can use specific URLs, e.g.
  ```bash
  # default service would be called
  https://{PROJECT_ID}.{REGION_ID}.r.appspot.com
  # specific service would be called
  https://{SERVICE}-dot-{PROJECT_ID}.{REGION_ID}.r.appspot.com
  # specific service version would be called
  https://{VERSION}-dot-{SERVICE}-dot-{PROJECT_ID}.{REGION_ID}.r.appspot.com
  ```
- **Traffic splitting**: Incoming traffic can be split between specific service versions in App Engine or specified in
  Cloud Load-Balancing.

> NOTE: App Engine support multiple ways of how traffic can be split between multiple service versions:
> - **IP splitting**: based on the request IP address a specific service version would be chosen to serve the traffic.
> - **Cookie splitting**: traffic would be split based on the cookie that can be controlled via the application itself
    and allow specific users access to a specific version of the service. Cookie can be via `GOOGAPPUID` env. var.
> - **Random**: traffic is served between the versions randomly.

### Google Kubernetes Engine (GKE)

Google Kubernetes Engine (GKE) is a managed, production-ready environment for running containerized applications that
require specific orchestration needs.

#### Key Features:

- **Manage environment**: Google Cloud handles the underlying infrastructure allowing developers to focus more on
  deploying and running the applications.
- **Kubernetes Native**: As GKE is composed out of Kubernetes, it allows developers to run a number of open-source tools
  that offer rich and robust experiences around application build, deploy, and management.
- **Enterprise-Grade Security**: Google Cloud provides encryption on rest, private registries for Docker images, data
  encryption in transit, and secure access controls.
- **Multi-regional Coverage**: By utilizing global load-balancing, applications can be deployed in multiple regions
  ensuring high availability.
- **Scaling**: GKE provides autoscaling both for nodes and for applications based on traffic demands.

#### Models of operations

GKE provides two operational models:

|                       | Standard                                                                                                                                                                                                          | Autopilot                                                                                                 |
|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| Cluster management    | Standard mode provides more flexibility by allowing the user to specify their own node pools and nodes, configuration, and lifecycle.                                                                             | Google Cloud manages the nodes automatically, allowing the users to focus more on the application.        |
| Pricing               | Cost is calculated based on the uptime, network egress and associated resource of the provisioned worker nodes,                                                                                                   | Cost is associated with the running pods without any additional charges of the underlying infrastructure. |
| Resource optimization | Provides the flexibility to shape the cluster with taints, tolerations, and affinities, but user is required to ensure that resources are efficiently utilized by managing how workloads are scheduled and sized. | Automatically ensures efficient use of underlying resources.                                              |
| Workload support      | Supports all Kubernetes workload.                                                                                                                                                                                 | Supports majority of the workloads with some restrictions, such as privileged and DeamonSet workloads.    |
| Maintenance           | Upgrades and maintenance of nodes is handled by the user.                                                                                                                                                         | Maintained and handle by Google Cloud.                                                                    |

#### Cluster components

**Master node(s) (Control plane)**: is a set of components that collectively manage the state of the K8s cluster and
make the orchestration of containers possible. It consists of:

- **Kube-APIServer**: is the front-end of the control plane and exposes K8s API to users, devices, CLIs etc.
- **Kube-Scheduler**: component that schedules workloads to specific nodes in the cluster based on number of factors,
  such as resource availability and constrains.
- **Kube-controller-manager**: runs controllers that are background threads to handle routine tasks in the cluster, e.g.
  node controller for handling node failures, or replication controller for maintaining the correct number of pods.
- **Cloud-controller-manager**: runs a controller that interacts with the underlying cloud providers.
- **etcd**: is a consistent and highly-available key-value store user by K8s to keep all cluster data.

**Worker node(s)**: is a machine (physical or virtual) that runs applications using pods and managed by the control
plane. It consists of:

- **Kubelet**: an agent that ensures that containers are running in a pod by referencing to `PodSpecs` files.
- **Kube-proxy**: a proxy that manages network rules allowing communication to the pods from inside and outside the
  cluster.
- **Container runtime**: software that is responsible for running the containers, such Docker and CRI-O.

#### Cluster availability types

- **Zonal clusters**: have single control plane in a single zone, there are 2 types:
    - **Single-zone clusters**: has single control plane running in one zone that manages workloads on nodes within
      the same zone.
    - **Multi-zonal clusters**: has a single control plane running in a single zone that manages workloads on nodes
      running in multiple zones. In case of control plane unavailability, the worker nodes will continue to operate,
      however, they would be available for configuration until the control plane becomes available.
- **Regional clusters**: multiple replicas of the control plane, running in multiple zones within a given region. Nodes
  in a regional cluster can run in multiple or single zones depending on the configured node locations.

#### Cluster versions

> NOTE: it's recommended to enable auto-upgrade option for the cluster and it's nodes. GKE automatically upgrades nodes
> for Autopilot clusters.

- **Release channel**: by default clusters are enrolled to the regular release channel, however, GKE allows to enroll to
  any [release channel](https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels).
- **Specific version**: cluster can be created with a specific supported version of K8s.
- **Default version**: if subscribing to a release channel is not required, instead of specifying a version cluster can
  be created with a default version that is selected based on usage and real-world performance, and is changed
  regularly.

#### Cluster networking

- **VPC-native cluster**: uses alias IP range for its pods, allowing them to have direct connectivity to other VMs in
  the VPC network and external networks, without using a NAT gateway. This type of clusters allows shared VPCs and have
  control over pod IPs with firewall rules and route tables.
- **Routes-based clusters (non-alias IP)**: uses network routes for each node inside the VPC, directing the traffic
  meant for the pod to its respective node. Each node is associated with a single route for the pod with a limited
  number of routes per node.

By default, routes to public networks are not configured automatically and require manual configuration. Private
clusters
assign internal addresses to pods and nodes, and workloads are completely isolated from public networks.

#### Components

**Service**: is an abstract way of exposing the pod to the outside world, providing built-in support for service
discovery using a stable IP address and DNS name, load-balancing between the pods, and stable IP address even though
pods can change over time. Type of service include:

- **ClusterIP**: exposes the service on an internal IP in the cluster, making the service reachable only within the
  cluster.
- **LoadBalancer**: exposes the service externally using a cloud provided load-balancer (not recommended if cluster
  requires to expose multiple services).
- **NodePort**: exposes the service on each node's IP at a static port, making the service accessible
  via `{NODE_IP}:{NODE_PORT}`.
- **External name**: maps a service to the contents of the `externalName` field, by returning a CNAME record with its
  value (e.g. foo.bar.example.com).

#### Useful commands

Generate connection configuration for `kubectl` for your cluster:

```bash
gcloud container clusters get-credentials {CLUSTER_NAME} --zone {ZONE_ID} --project {PROJECT_ID}
```

Create a cluster:

```bash
gcloud container clusters create {CLUSTER_NAME} --zone {ZONE_ID} --node-locations {ZONE_ID},{ZONE_ID}
```

Resize the cluster:

```bash
gcloud container clusters resize {CLUSTER_NAME} --node-pool {NODE_POOL} --num-nodes {NUMBER_OF_NODES}
```

Autoscale a cluster:

```bash
gcloud container clusters update {CLUSTER_NAME} --enable-autoscaling --min-nodes {MIN_NUMBER_OF_NODES} --max-nodes {MAX_NUMBER_OF_NODES}
```

Delete a cluster:

```bash
gcloud container clusters delete {CLUSTER_NAME}
```

Adding node pool:

```bash
gcloud container node-pools create {NODE_POOL_NAME} --cluster {CLUSTER_NAME}
```

List container images:

```bash
gcloud container images list
```

### Cloud Functions

Cloud Functions is a serverless execution environment for building and connecting cloud services, allowing to execute
code in response to events without needing to provision or manage servers.

#### Key features

- **Event-driven computing**: functions are executed in response to events that can originate from GCP services such as
  Pub/Sub, Cloud Storage, Firestore, or via HTTP.
- **Automatic scaling**: functions are automatically scaled up/down in response to incoming traffic, making them useful
  for unpredicted load changes.
- **Connect and extend services**: functions can easily integrate with other GCP services, allowing for seamless flow of
  data and processing from service to service.
- **Security**: invocation are automatically authenticated using service-to-service authentication.
- **Observability**: functions are integrated with GCP monitoring services for gaining insights into the behaviour of
  the function.
- **Cost**: functions are priced with pay-as-you-go scheme, meaning that charges are not applied if the function is not
  running.

#### Variants

|                            | Gen1                                                | Gen2                                             |
|----------------------------|-----------------------------------------------------|--------------------------------------------------|
| Scaling                    | Standard scaling                                    | Rapid scaling                                    |
| Concurrent executions      | Single request per instance                         | Multiple requests per instance                   |
| Memory and CPU allocations | Limited options                                     | Fine-grained control                             |
| Pricing                    | Based on invocations, compute time, network traffic | Factors from Gen1 + CPU and memory configuration |
| Minimum idle instances     | Not available                                       | Available                                        |
| Scaling                    | Wide range available                                | Limited set of runtimes                          |

### Cloud run and Cloud run for Anthos

Cloud Run is a fully managed serverless execution environment for running containers making it easy to deploy, manage,
secure, and scale applications.

#### Key features

- **Serverless**: all infrastructure provisioning is handled by Google Cloud, thus Cloud Run allows developers to focus
  on building quality application.
- **Auto-scaling**: Cloud run automatically scales up/down container instances based on traffic. Containers can be
  scaled down to 0 instances, meaning that subsequent request might be affected by cold start.
- **HTTPs by default**: every service deployed gets a stable, secure HTTPS endpoint, allowing easy web development and
  integrations.
- **Portable**: since Cloud Run is build on [Knative](https://knative.dev/docs/concepts/) technology, application can be
  moved across different environments.
- **Observability**: integration with Google Cloud services for improved observability of overall health of the running
  application.
- **IAM and VPC security**: integration with IAM and VPC for secure and private connections, allowing granular access
  control to the services.
- **Pay-as-you-go**: Cloud Run cost is based on the amount of vCPU, memory, and Egress network traffic the application
  uses during its execution. Note that if a request triggers a cold start, the cost could get higher due to the
  resources required to trigger the initialization of the container instance.

#### Difference between Cloud Run and Cloud Run for Anthos

| Feature                         | Cloud Run                                                          | Cloud Run for Anthos                          |
|---------------------------------|--------------------------------------------------------------------|-----------------------------------------------|
| Platforms                       | Google Cloud                                                       | Google Cloud, on-premises, other clouds       |
| Infrastructure Management       | Fully managed by Google                                            | User manages Kubernetes cluster               |
| Autoscaling                     | Automatic scale up and down to zero                                | Automatic scale up and down                   |
| Concurrent Requests             | Handles multiple requests per container instance                   | Default is one request per container instance |
| Networking                      | Uses Google's global load balancing                                | Optionally uses Istio                         |
| Service Mesh Integration        | Not available                                                      | Available through Istio                       |
| Custom Network Configurations   | Not available                                                      | Available                                     |
| Access Private GCP Resources    | Requires Serverless VPC Access                                     | Direct access within the cluster network      |
| Observability Tools             | Cloud Logging, Cloud Monitoring                                    | Istio, Stackdriver, Prometheus, Grafana       |
| Continuous Delivery Integration | Cloud Build, Tekton (through Cloud Run for Anthos on Google Cloud) | Tekton                                        |

#### Useful commands

Deploy a new container:
```bash
gcloud run deploy {SERVICE_NAME} --image {IMAGE_URL} --revision-suffix {REVISION}
```

List available revisions:
```bash
gcloud run revisions list
```

Adjust traffic assignments
```bash
gcloud run services update-traffic {SERVICE_NAME} --to-revisions={REVISION}:{TRAFFIC_ALLOCATION},{REVISION}:{TRAFFIC_ALLOCATION}
```

