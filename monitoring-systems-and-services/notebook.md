# Monitoring Systems and Services with Prometheus (LFS241)

## Table of contents:

- **[Systems and Service Monitoring](#systems-and-service-monitoring)**

## Systems and Service Monitoring

There are several ways to monitor production systems and services:
- **_Check-based fault detection_** is a type of monitoring, in which the monitoring system executes periodic check scripts on hosts to ensure that the hosts and services running on them are currently up, running, and healthy. When a check fails, the monitoring system sends a notification to an operator who then takes action. Unfortunately, check-based monitoring solutions aren't reliable enough in dynamic environments due to fact that they were designed to work in a more static configuration environments.
- **_Log/Event based monitoring_** collects detailed information about all relevant events (e.g. all processed HTTP requests) that happen in a system and processing them either for general insight or for alerting. Raw event data provides extremely detailed insight into a system, but shipping, storing, and processing all individual events becomes very expensive once a system generates a high volume of events. This is especially true for high-traffic websites, where the cost of log processing is directly proportional to your user traffic.
- **_Metrics based monitoring_** periodically samples the current numeric value of an evolving measurement (such as the current memory usage or the total number of handled HTTP requests for every URL path) and appends the resulting sample to a time series database. While losing per-event granularity, metrics still provide a great level of insight into overall system health.
- **_Request tracing_** is a special form of event logging that focuses on tracing individual requests across processing stages or service boundaries. Request tracing provides deep insight into the overall lifecycle of a request and is especially helpful in determining which processing stages or sub-services can benefit most from optimizations. The main downside is that request tracing only works when all components cooperate in recording trace spans and passing on trace identifiers for a request to the next stage. Otherwise, correlation across service boundaries becomes impossible.

The below figure gives an overview of Prometheus system architecture:

![Prometheus system architecture](resources/img/prometheus_system_architecture.png)


