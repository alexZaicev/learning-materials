## Networking

### Virtual Private Cloud (VPC)

**Virtual private cloud (VPC)** is a fundamental networking resource that provides a virtualized private network within
the Google Cloud environment. A VPC allows you to create and manage a logically isolated section of the Google Cloud
where you can launch and operate your resources in a highly secure and customizable network environment.

#### Key features and aspects

- **Global Resource:** Unlike some cloud providers where VPCs are regional, a GCP VPC is a global resource. This means a
  single VPC can span multiple regions and zones around the world, simplifying network architecture for global
  applications and providing a unified view of your network.
- **Subnets:** Within a VPC, you define subnets, which are regional resources. Each subnet is associated with a single
  region and has a designated private IP address range (using CIDR notation). Resources launched in a subnet, such as
  Compute Engine instances, automatically receive a private IP address from this range.
- **IP Addressing:** VPCs support both IPv4 and IPv6 addressing. When you create a VPC, you choose a private IPv4 range,
  and Google Cloud automatically creates default subnets in each region. You have the flexibility to add, remove, or
  modify subnets as needed.
- **Connectivity Options:**
    - _**Internal Connectivity:**_ Resources within the same VPC can communicate using their internal IP addresses, even
      across different regions, thanks to Google's global network.
    - **_External Connectivity:_** You can assign external IP addresses to resources for internet access or use Cloud
      NAT for outbound connections without public IPs.
    - **_VPC Peering:_** Connect two VPCs to allow private RFC 1918 connectivity across them.
    - **_Shared VPC:_** Share a common VPC network across multiple projects within an organization.
    - **_Cloud VPN and Cloud Interconnect:_** Securely connect your VPC to on-premises networks.
- **_Firewalls:_** GCP VPCs come with a distributed, software-defined firewall that allows you to create rules based on
  IP addresses, subnets, and tags. These stateful firewalls control incoming and outgoing traffic at the instance level,
  providing fine-grained security without needing to run firewall software on your instances.
- **_Routes:_** VPCs have routing tables that define how packets are forwarded. By default, routes are created for
  subnets to enable communication, but you can create custom static routes or use Cloud Router for dynamic routing with
  on-premises networks.
- **_Flow Logs and Monitoring:_** VPC Flow Logs capture network flows, which can be exported to Cloud Logging and
  BigQuery for analysis, aiding in network monitoring, forensics, and optimization.
- **_Private Google Access:_** This feature allows resources in your VPC to access Google APIs and services using
  private IP addresses, reducing exposure and egress costs.
- **_Alias IP Ranges:_** Assign multiple IP addresses to a single VM interface, useful for containers or hosting
  multiple services on one VM.
- **_Service Controls:_** Use VPC Service Controls to create security perimeters around sensitive data in Google Cloud
  services, mitigating data exfiltration risks.
- **_Network Performance and SLAs:_** Google's premium tier networking offers low latency and high throughput, backed by
  SLAs for availability and performance.

#### Shared VPC

GCP's shared VPC allows an organization to connect resources from multiple projects to a common VPC network, enabling
private communication between projects while maintaining centralized network control. In this model, a host project owns
the shared VPC and its resources (subnets, firewalls, routes), while service projects are granted permission to use this
network. This setup creates a hub-and-spoke architecture that simplifies management and enhances security through
consistent policy enforcement.

Key benefits of Shared VPC include centralized control for network administrators, security isolation between projects,
accurate cost allocation, scalability for growing organizations, and reduced complexity compared to managing multiple
independent VPCs. It integrates with other GCP features like Private Service Access and VPC Flow Logs, further expanding
its utility. Common use cases range from enterprise segmentation and development/testing environments to providing
controlled access for external partners.

The Shared VPC concept embodies a separation of resource ownership from resource use, acknowledging that in large
organizations, network users (like developers) often differ from those responsible for network design and security. By
bridging this gap, Shared VPC helps organizations build more secure, manageable, and cost-effective cloud environments,
though users should be aware of certain limitations, such as the number of service projects per host and
service-specific requirements.

#### VPC Peering

GCP's VPC Peering enables private RFC 1918 connectivity between two Virtual Private Cloud (VPC) networks, regardless of
whether they belong to the same project or organization. This allows resources in each VPC to communicate with one
another using internal IP addresses, as if they were part of the same network, without relying on external IP addresses
or VPNs.

In a VPC peering relationship, each VPC is considered a peer to the other. Peering is a bilateral arrangement: if VPC A
peers with VPC B, then VPC B is automatically peered with VPC A. However, peering is not transitive, meaning if VPC A
peers with VPC B, and VPC B peers with VPC C, it doesn't imply that VPC A can communicate with VPC C. This
non-transitivity helps maintain network boundaries and security.

Key benefits of VPC Peering include reduced network latency by using Google's internal network rather than the public
internet, enhanced security by keeping traffic private, and lower costs by avoiding egress charges for traffic between
peered VPCs. It's particularly useful for scenarios like connecting production and development environments, data
replication across projects, or enabling communication between different organizational units with separate VPCs.

However, VPC Peering has limitations. Notably, peered VPCs cannot have overlapping IP ranges, which can complicate setup
for VPCs not initially designed to be peered. Also, certain resources and services, like Cloud SQL instances or internal
load balancers, are not accessible across peers. For situations requiring more advanced routing, shared administrative
control, or transitive connectivity, organizations might consider Shared VPC instead of or alongside VPC Peering.

#### Hybrid cloud (On-premise + GCP)

**Cloud VPN** securely connects your on-premises network to your GCP VPC through an IPsec VPN tunnel over the public internet. Cloud VPN option:

1. _HA VPN (High Availability VPN):_
   - Provides 99.99% service availability SLA.
   - Supports site-to-site VPN and can connect to peer VPNs that support BGP (Border Gateway Protocol).
   - Each HA VPN gateway has two interfaces, each with its own public IP address for redundancy.
   - Automatically chooses two external IP addresses from two different Google Cloud regions for diversity.
2. _Classic VPN:_
   - The original GCP VPN offering, now recommended only for specific use cases not covered by HA VPN.
   - Supports both static and dynamic routing (with Cloud Router).
   - Does not offer an SLA unless used in a specific active/active configuration.

Cloud VPN is often the quickest and most cost-effective way to set up hybrid connectivity, especially for smaller data transfer needs or when getting started with hybrid cloud.

**Cloud Interconnect** is offered for organizations requiring higher bandwidth and more reliable connections than possible over the public internet. Cloud Interconnect options:

1. _Dedicated Interconnect:_
   - Provides direct physical connections between your on-premises network and Google's network.
   - Offers 10 Gbps or 100 Gbps links per Interconnect connection.
   - Lower latency and higher security than VPN solutions.
   - Can connect directly to GCP or via a supported service provider.
   - Eligible for certain GCP pricing benefits like egress fee waiver.
2. _Partner Interconnect:_
   - Connects your on-premises network to GCP through a supported service provider.
   - Useful when you can't meet Dedicated Interconnect's colocation requirements or need less than 10 Gbps of bandwidth.
   - Offers connectivity from 50 Mbps to 10 Gbps.
   - More flexible in terms of contract length and technical requirements than Dedicated Interconnect.

Both Interconnect options bypass the public internet, providing more consistent network performance and enhanced security.

**Cloud Router** while not a connectivity option itself, it plays a crucial role in hybrid setups:
- Enables dynamic routing between your VPC and on-premises network using BGP.
- Works with both Cloud VPN and Cloud Interconnect.
- Automatically learns routes to reach your on-premises network and advertises routes to your VPC networks.
- Simplifies network management by eliminating the need to manually update routes when network topology changes.
- Supports graceful restart to minimize disruption during planned maintenance.

Cloud Router is particularly valuable in complex or changing network environments, as it removes the need to configure static routes and adapts automatically to network changes.

> These hybrid connectivity options can be used individually or in combination:
> - You might start with Cloud VPN for initial connectivity, then upgrade to Cloud Interconnect as data transfer needs grow.
> - Use multiple Cloud VPN tunnels or Interconnect connections for redundancy.
> - Employ Cloud Router with any of these options to simplify routing management.
