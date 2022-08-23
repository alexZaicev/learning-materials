# Kubernetes fundamentals (LFS258)

## Table of contents:

- **[Basics of K8s](#basics-of-k8s)**
- **[Simple Pod](#simple-pod)**
- **[APIs and Access](#apis-and-access)**
- **[Managing state with deployment](#managing-state-with-deployment)**
- **[Volumes and Data](#volumes-and-data)**
- **[Services](#services)**

For information on how to configure your machine to follow along this guide please see the [Installation Guide](installation_guide.md).

## Basics of K8s

---

### Architecture

K8s consists of control plane (CP) and worker nodes, where CP runs an API service, scheduler, controllers, storage system to keep the state of the cluster, container settings, and networking configurations.
- `kubelet` - systemd process running on each node that accepts the API calls for Pod specification (aka. `PodSpec`) and will work to configure the local node until the specification has been met.
- `kube-apiserver` - API server serving REST operation and provides the frontend to the cluster's shared state through which all other components interact. API server validates and configures data for the API object which include pods, services, replication controllers etc.
- `kube-scheduler` - CP process that assigns pods to nodes determining which nodes are valid placements for each pod in the scheduling queue according to constraints and available resources. 
- `kube-proxy` - process running on every node, creates and manages networking rules to expose the container on the network to other containers or the outside world.
- `kube-controller-manager` - daemon control loop that watches the shared state of the cluster through the API server and makes changes attempting to move current state towards the desired state, e.g. replication controller, endpoint controller etc.
- `etcd` - database that stores the state of the cluster, and other persistent information in a b+tree key-value store. Instead of finding and changing an entry, values are always appended to the end and previous copies of the data are then marked for future removal by a compaction process.
- K8s provides a DNS pod and service that can be used to resolve DNS request to resolve pod and service names (DNS records are only created for Pods and Services).   

![Architecture](resources/img/architecture.png)

### Terminology

- **Namespaces** - a mechanism for isolating groups of resources within a single cluster. Names of resources need to be unique withing the namespace, but not across namespaces.
- **Label** - key:value pair used to organize and select groups of objects. Useful for filtering.
- **Annotations** - metadata that is not used by selector, but instead can be used by 3rd application or tools.
- **Node** - physical or virtual machine that serves as a worker in K8s. Each node is managed by CP and containers the services necessary to run pods.
- **Taints** - node configuration that allows to refuse pod assignments.
- **Toleration** - is a pod metadata that allows scheduler to schedule pods with matching taints.
- **Controllers**  - are watch-loops that monitor and modify the state of the cluster by interacting with the API server. Controllers are compiled into `kube-controller-manager`, however, other controllers may be added using custom resource definition.
  - _Informer_ - uses API server as a source to request the state of an object via an API call (received data is cached).
  - _SharedInformer_ - identical to _Informer_, with one difference - created cache is shared for multiple requests.
  - _Workqueue_ - uses a key to hand out tasks to various workers. The standard Go work queues of rate limiting, delayed, and time queue are typically used.
- **Workloads:**
  - **Pods** - are the smallest deployable units of computing that can be created and managed in K8s. Pod consists of one or more containers, with shared storage and network resources, and a specification for how to run the containers. Contents of the pod are always co-located and co-scheduled, and run in a shared context.
  - **Workload resources:**
      - **Deployments** - provides declarative updates for pods and replicaSets (serves as an abstraction over pods). Deployment controller changes the actual state to the specified desired state at a controlled rate.
      - **ReplicaSet** - maintains stable set of replica pods running at any given time. It's often used to guarantee the availability of a specified number of identical pods.
      - **StatefulSet** - similar to deployment it manages pods based on their spec, however, it maintains a sticky identity for each pod. StatefulSet provides guarantees about the ordering and uniqueness of the pods. (e.g. database deployment will be managed by statefulSets that would eliminate data inconsistencies)
      - **DaemonSet** - ensures that all (or some) nodes run a copy of a pod. Pods are added or garbage collected if node is added or removed from the cluster.
      - **ReplicationController** - ensure that a specific number of pods is running at any one time, providing ability to do rolling updates. 
- **Services, Load balancing and networking:**
  - **Service** - abstraction that defines a logical set of pods and a policy by which to access them. It has two main functionalities (1) permanent IP address (static) that can be used instead of pod IP address, (2) load balancer. Because lifecycle of pod and service is not connected, if a pod dies, service will still remain active.
  - **Ingress** - an API object that manages external access to the services in a cluster (forwards external requests to internal services).
      ![Ingress](resources/img/ingress.svg)
- **Storage:**
  - **Volumes** - abstraction serving as a data persistence for pods that attaches storage on local machine or outside the cluster.
- **Configuration:**
  - **ConfigMap** - non-confidential key-value pair configuration that is consumed by pods via env. variables, CLI arguments or configuration file in volume.
  - **Secrets** - similar to ConfigMap, however, they are specifically designed to hold sensitive data, such as passwords, tokens or keys.

### Components

![Components](resources/img/components.png)

### Single IP per Pod

![Pod Network](resources/img/pod_network.png)

The graphic shows a pod with two containers, A and B, and two data volumes, 1 and 2. Containers A and B share the network namespace of a third container, known as the pause container. The pause container is used to get an IP address, then all the containers in the pod will use its network namespace. To communicate with each other, containers within pods can use the loopback interface, write to files on a common filesystem, or via inter-process communication (IPC).

### Container to Outside Path

![Container to Outside Path](resources/img/container_outside_path.png)

Even though there are two containers, they share the same namespace and the same IP address, which would be configured by kubectl working with kube-proxy. The IP address is assigned before the containers are started, and will be inserted into the containers. The container will have an interface like eth0@tun10. This IP is set for the life of the pod.

The endpoint is created at the same time as the service. Note that it uses the pod IP address, but also includes a port. The service connects network traffic from a node high-number port to the endpoint using iptables with ipvs on the way. The kube-controller-manager handles the watch loops to monitor the need for endpoints and services, as well as any updates or deletions.

### Services

![Services](resources/img/services.png)

This graphic shows a pod with a primary container, App, with an optional sidecar Logger. Also seen is the pause container, which is used by the cluster to reserve the IP address in the namespace prior to starting the other pods. This container is not seen from within Kubernetes, but can be seen using docker and crictl.

This graphic also shows a ClusterIP which is used to connect inside the cluster, not the IP of the cluster. As the graphic shows, this can be used to connect to a NodePort for outside the cluster, an IngressController or proxy, or another ”backend” pod or pods.

## Simple Pod

---

The bellow YAML file contains specifications for simple pod that will be deployed in your K8s cluster. Create a new file `simple-pod.yaml` and copy the content bellow.
```yaml
apiVersion: v1
kind: Pod
metadata:
    name: firstpod
spec:
    containers:
    - image: nginx
      name: stan 
```

Run the following commands:
```bash
# create a new pod
$> kubectl create -f simple-pod.yaml 
# check that pod was created 
$> kubectl get pods
# get pod object as YAML output
$> kubectl get pod simple-pod -o yaml
# delete our pod
$> kubectl delete pod simple-pod
```

## APIs and Access 

---

Kunernetes entire architecture is build with powerful REST-based APIs, e.g. `kubectl` make API calls on your behalf (`kubectl` can be replaced with standard cURL or 3rd party program to interact with K8s).

### Access checking

The following `kubectl` command can be used to query current authorization for administrator or another user:
```bash
# check authorizations for current user
$> kubectl auth can-i create deployments
# check authorizations for another user in a namespace
$> kubectl auth can-i create deployments --as foo --namespace bar
```

There are currently three APIs which can be applied to set who and what can be queried:
- **SelfSubjectAccessReview** - Access review for any user, helpful for delegating to others. 
- **LocalSubjectAccessReview** - Review is restricted to a specific namespace.
- **SelfSubjectRulesReview** - A review which shows allowed actions for a user within a particular namespace. 

**Note:** The use of reconcile allows a check of authorization necessary to create an object from a file. No output indicates the creation would be allowed.

### Namespaces

- `default` - namespace for keeping all resources, unless specified otherwise.
- `kube-node-lease` - namespace for keeping worker node lease information.
- `kube-public` - namespace that is available for everybody (including unauthenticated users), containing general information.
- `kube-system` - namespace containing infrastructural pods.

**Note:** If you would like to see all resource on the system you can run the following `kubectl get --all-namespaces pods`

## Managing state with deployment

---

![Nested objects](resources/img/nested_objects.png)

The graphic in the upper left represents a container running nginx 1.11. Kubernetes does not directly manage the container. Instead, the kubelet daemon checks the pod specifications by asking the container engine, which could be Docker or cri-o, for the current status. The graphic to the right of the container shows a pod which represents a watch loop checking the container status. kubelet compares the current pod spec against what the container engine replies and will terminate and restart the pod if necessary.

A multi-container pod is shown next. While there are several names used, such as sidecar or ambassador, these are all multi-container pods. The names are used to indicate the particular reason to have a second container in the pod, instead of denoting a new kind of pod.

On the lower left we see a replicaSet. This controller will ensure you have a certain number of pods running. The pods are all deployed with the same podSpec, which is why they are called replicas. Should a pod terminate or a new pod be found, the replicaSet will create or terminate pods until the current number of running pods matches the specifications. Any of the current pods could be terminated should the spec demand fewer pods running.

The graphic in the lower right shows a deployment. This controller allows us to manage the versions of images deployed in the pods. Should an edit be made to the deployment, a new replicaSet is created, which will deploy pods using the new podSpec. The deployment will then direct the old replicaSet to shut down pods as the new replicaSet pods become available. Once the old pods are all terminated, the deployment terminates the old replicaSet and the deployment returns to having only one replicaSet running.

## Volumes and Data

---

The below Yaml specification will create a Pod with a single container with a volume named `scratch-volume` of storage type `emptyDir`. The kubelet will create the directory in the container, but not mount any storage. Any data created is written to the shared container space. As a result, it would not be persistent storage. When the Pod is destroyed, the directory would be deleted along with the container. 
```yaml
apiVersion: v1
kind: Pod
metadata:
    name: fordpinto 
    namespace: default
spec:
    containers:
    - image: simpleapp 
      name: gastank 
      command:
        - sleep
        - "3600"
      volumeMounts:
      - mountPath: /scratch
        name: scratch-volume
    volumes:
    - name: scratch-volume
            emptyDir: {}
```

### Types

- `GCEpersistentDisk` and `awsElasticBlockStore` - are GCE and AWS specific volume types that allow you to mount GCE and EBS disks in your pods.
- `emptyDir` - is an empty directory that gets erased when pod dies.
- `hostPath` - mounts a resource from host node filesystem. Resource can be directory, file socket, or block device. The resource should already exist on the host node. There are two types, `DirecotoryOrCreate` and `FileOrCreate`, that create resource on the host and use them if they don't already exist.
- NFS (Network File System) and iSCSI (Internet Small Computer System Interface) - straightforward choices for multiple reader scenarios.

Many more volume type exist (and many more are added) that are not listed. For more information navigate to [Kubernetes official volumes documentation](https://kubernetes.io/docs/concepts/storage/volumes/)

### Persistent Volumes

Persistent volume - is a storage abstraction used to retain data longer than the pods using it. Pods define `persistentVolumeClaim` or `pvc` with various parameters for size and the type of backend storage - `StorageClass`. Cluster then attaches `persistentVolume` as a response. Persistent volume stages:
- Provisioning can be from PVs created in advance by the cluster administrator, or requested from a dynamic source, such as the cloud provider.
- Binding occurs when a control loop on the cp notices the PVC, containing an amount of storage, access request, and optionally, a particular StorageClass. The watcher locates a matching PV or waits for the StorageClass provisioner to create one. The PV must match at least the storage amount requested, but may provide more.
- The use phase begins when the bound volume is mounted for the Pod to use, which continues as long as the Pod requires.
- Releasing happens when the Pod is done with the volume and an API request is sent, deleting the PVC. The volume remains in the state from when the claim is deleted until available to a new claim. The resident data remains depending on the persistentVolumeReclaimPolicy.
- The reclaim phase has three options:
  - Retain, which keeps the data intact, allowing for an administrator to handle the storage and data. 
  - Delete tells the volume plugin to delete the API object, as well as the storage behind it.
  - The Recycle option runs a `rm -rf /mountpoint` and then makes it available to a new claim. With the stability of dynamic provisioning, the Recycle option is planned to be deprecated.

The below Yaml specification creates a basic persistent volume using the `hostPath` type.
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
    name: 10Gpv01
    labels: 
        type: local 
spec:
    capacity: 
        storage: 10Gi
    accessModes:
        - ReadWriteOnce
    hostPath:
        path: "/foo/bar"
```

**Note:** Persistent volumes aren't namespace objects, however, persistent volume claims are.

The below Yaml specification creates a basic persistent volume claim for above volume. This claim can be now specified in Pod specification.
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: fooClaim
spec:
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
                storage: 8GI
```

Dynamic provisioning allows cluster to request storage from an exterior, pre-configured source. API calls made by the appropriate plugin allow for a wide range of dynamic storage use. The `StorageClass` API resource allows an administrator to define a persistent volume provisioner of a certain type, passing storage-specific parameters. With a `StorageClass` created, a user can request a claim, which the API Server fills via auto-provisioning. The resource will also be reclaimed as configured by the provider.

The below Yaml specification creates `StorageClass` for GCE.
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: foo
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
```

Reclaim policy `persistentVolumeReclaimPolicy` defined in `PersistentVolume` determines how the storage resources can be reused when it is no longer needed:
- Retain - data will not be deleted unless manually requested
- Recycle - deletes all the data by removing its files. This can be useful to reuse a disk that is not dynamically provisioned, for example a NFS disk 
- Delete - deletes the underlying storage (only applies on cloud storage, some StorageClasses won't be able to delete the underlying disk)


When more than one namespace share some kind of resource (e.g. volume) there is always a chance that one of namespaces will use more resources than others. This is when `ResourceQuata` comes in handy. `ResourceQuota` provides constraints that limit aggregate resource consumption per namespace. It can limit the quantity of objects that can be created in a namespace by type, as well as the total amount of compute resources that may be consumed by resources in that namespace.

The below Yaml specification will create a `ResourceQuota` on persistent volume claim.
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: storagequota
spec:
  hard:
    persistentvolumeclaims: "10"
    requests.storage: "500Mi"
```

## Services

---

### Types

- `ClusterIP` - is the default, and only provides access internally (except if manually creating an external endpoint). The range of ClusterIP used is defined via an API server startup option.
- `NodePort` - is great for debugging, or when a static IP address is necessary, such as opening a particular address through a firewall. The NodePort range is defined in the cluster configuration.
- `LoadBalancer` - was created to pass requests to a cloud provider like GKE or AWS. Private cloud solutions also may implement this service type if there is a cloud provider plugin, such as with CloudStack and OpenStack. Even without a cloud provider, the address is made available to public traffic, and packets are spread among the Pods in the deployment automatically.
- `ExternalName` - has no selectors, nor does it define ports or endpoints. It allows the return of an alias to an external service. The redirection happens at the DNS level, not via a proxy or forward. This object can be useful for services not yet brought into the Kubernetes cluster. A simple change of the type in the future would redirect traffic to the internal objects.

The controllers of services and endpoints run inside the `kube-controller-manager` and send API calls to the `kube-apiserver`. API calls are then sent to the network plugin, such as `calico-kube-controller`, which then communicates with agents on each node, such as `calico-node`. Every `kube-proxy` is also sent an API call so that it can manage the firewall locally. The firewall is often iptables or ipvs. The `kube-proxy` mode is configured via a flag sent during initialization, such as `mode=iptables`, and could also be IPVS or userspace.

![Services diagram](resources/img/services_diagram.png)

### Overall Network View

An example of a multi-container pod with two services sending traffic to its ephemeral IP can be seen in the diagram below. The diagram also shows an ingress controller, which would typically be represented as a pod, but has a different shape to show that it is listening to a high numbered port of an interface and is sending traffic to a service. Typically, the service the ingress controller sends traffic to would be a ClusterIP, but the diagram shows that it would be possible to send traffic to a NodePort or a LoadBalancer.

![Cluster networking](resources/img/cluster_networking.png)

### DNS

The use of `CoreDNS` allows for a great amount of flexibility. Once the container starts, it will run a Server for the zones it has been configured to serve. Then, each server can load one or more plugin chains to provide other functionality. As with other microservices, clients would it access using a service, `kube-dns`.



