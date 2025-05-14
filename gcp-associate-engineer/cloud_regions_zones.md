## Cloud Regions and Zones

### What is region?

A region is a collection of zones that share high-bandwidth, low-latency network connections between
each other. 

### What is zone? 

A zone is a deployment area within a region. The fully-qualified name for a zone is made up of 
`<region>-<zone>`. For example, the fully qualified name for zone a in region `us-central1` is
`us-central1-a`.

### Why multi-region / multi-zone?

- to lower latency for users around the globe
- high availability
- adherence to specific government regulations 

### How to select location?

- **Communication within and across regions will incur different costs.** 
  Generally, communication within regions will always be cheaper and faster than communication 
  across different regions.
- **Design important systems with redundancy across multiple zones or regions.**
  At some point in time, your instances might experience an unexpected failure. To mitigate the 
  effects of these possible events, you should duplicate important systems in multiple zones and 
  regions.
