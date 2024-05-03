## Cloud Load-balancing

A service that distributes incoming network traffic across multiple resources to ensure high availability, reliability,
and scalability of the applications.

There are several types of load-balancers available:

- **Global load balancing**: distributes traffic across multiple regions and availability zones, providing high-latency
  access to applications worldwide. Provides seamless failover, load distribution based on proximity, and support for
  multi-region deployments.
- **HTTP(S) load balancing**: OSI L7 load balancer, distributing HTTP and HTTPS traffics based on advanced
  content-based routing rules. Provides SSL termination, URL-based routing, health checking, and integration with MIGs.
- **Network load balancing**: OSI L4 load balancer, distributing TCP/UDP traffic across multiple instances withing a
  single region. Provides high-performance and low-latency load balancing for non-HTTP/HTTPS traffic, health checking
  and failover.
- **Internal load balancing**: distributes traffic across backend instances within VPC network. Provides load-balancing
  internal-facing applications, traffic isolation within a VPC, and integration with regional resources.
- **TCP/SSL proxy load balancing**: TCP/SSL proxy load balancing terminates TCP or SSL traffic at the load balancer,
  allowing it to inspect packets and make routing decisions. Provides SSL termination, content-based routing, and
  support
  for non-HTTP/HTTPS protocols.

Key features include:

- **Health checks and failover**: performs health checks on backend instances and automatically removes the unhealthy
  instances from the pool.
- **Auto-scaling and managed instance groups**: integration with managed instance groups allow for automatic scaling of
  backend instances based on traffic demand.
- **Traffic splitting and A/B testing**: traffic splitting and A/B testing features enable routing a portion of traffic
  to different versions of applications or backend services.
- **CDN integration**: improves performance by caching and delivering content closer to users.

Terminology:

- **Backend**: a pool of resources, typically VMs or other services that receive incoming network traffic from the
load-balancer.
- **Frontend**: entry point or interface through which incoming traffic is received by the load balancer. it handles
incoming traffic from clients and distributed the to the appropriate backend resources based on predefined routing
rules.

### How to choose the right load-balancer?

<img src="https://cloud.google.com/load-balancing/images/choose-lb.svg" style="background-color: whitesmoke">
