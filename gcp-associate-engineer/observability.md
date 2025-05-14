## Observability

**Observability** in the context of cloud computing refers to the ability to understand the internal state of your
system by examining its outputs. It encompasses practices and tools to monitor and analyze how your application is
performing and diagnose any issues. The concept is crucial in modern architectures like microservices and serverless,
where the system is distributed and failures need to be quickly identified and corrected.

#### Observability pillars

- **Monitoring:** It is the practice of continuously keeping an eye on your systems to ensure they're running smoothly
  and optimally. It usually involves the automated collection of data points, which are then visualized and alerted
  upon. Monitoring helps you understand the operational state of your system and is often the first line of defense
  towards identifying an issue.
- **Logging:** Logging is the process of recording events happening in your system. Logs are the line-by-line records
  that applications and systems generate, providing detailed information about requests, system events, errors, status,
  and even diagnostic information. Logs are one of the most direct ways to understand what's happening in a specific
  component or application at any given point in time.
- **Metrics:** Metrics are the quantitative measurements of your system's characteristics. This can be anything from
  system-level metrics (like CPU usage, memory consumption, network latency) to application-level metrics (like
  throughput, error rates, transaction volumes). Metrics data provides a high-level overview and are typically stored as
  time series data, enabling effective tracking of changes over time.

### Cloud Monitoring

**GCPs Cloud Monitoring** is a powerful service that allows you to understand the
performance, uptime, and overall health of your cloud-powered applications. It collects metrics, events, and metadata
from GCP projects and AWS accounts, hosted uptime probes, application instrumentation, and a variety of common
application components such as NGINX, Apache Web Server, Elasticsearch, and others.

#### Key features

- **Monitoring:** You can monitor the performance of your applications, witnessing robust health insights and reactive
  incident management. Google Cloud Monitoring automatically collects metrics from a large number of sources, including
  many popular applications and services.
- **Dashboards and Alerts:** With Cloud Monitoring, you can create custom dashboards to visualize your data and set up
  alerts to automatically notify when specific conditions are met. Alerts can be tied with uptime checks, which
  periodically check the availability and responsiveness of your services.
- **Log Integration:** Integrated with Google Cloud's Logging service, Cloud Monitoring allows you to access, analyze
  and filter log data from multiple sources, facilitating quick and precise troubleshooting.
- **Fully managed service:** As a fully managed service, you don't need to worry about the underlying infrastructure.
  You can focus on understanding and improving the performance of your applications.

### Cloud Logging

**GCPs Cloud Logging** is a robust tool that allows you to store, search, analyze, and monitor log data and events from
your cloud resources and applications. It gathers log data from a variety of sources, making it a centralized place to
understand your system's activities.

#### Key features

- **Centralized Logging:** Cloud Logging collects and stores logs from a wide variety of sources, including Google
  Cloud, Amazon Web Services, and customer-premises equipment, making it a single location for all your log data.
- **Log Search and Filtering:** With Cloud Logging, you can easily explore and filter logs based on various parameters,
  making it easier to find specific log entries for debugging or analytics purposes. The powerful search functionality
  enables you to find and view specific logs quickly when troubleshooting.
- **Log-based Metrics:** Cloud Logging not only stores your logs, but also lets you generate metrics based on the data
  in your logs. These log-based metrics can help you understand the count, distribution, and bucketing of log events.
- **Integration with Cloud Monitoring:** Cloud Logging integrates seamlessly with Google Cloud Monitoring. This
  integration allows you to create metrics, set up alerts, and visualize log data alongside other monitoring data,
  providing a comprehensive view of system status and health.
- **Retention and Export:** Google Cloud Logging retains logs for a period of time, after which they are automatically
  deleted. Should you need to preserve logs for longer periods, Cloud Logging lets you export logs to other products
  like Cloud Storage, BigQuery, or Pub/Sub.

#### Cloud audit logs

Audit logs in Google Cloud keep track of each activity in your Google Cloud environment. They help in answering the "who
did what, where, and when?" questions. All audit logs consist of log entries that record administrative activities in
your Google Cloud projects. They are automatically created and cannot be disabled.

**Types of audit logs:**

- _Admin Activity logs:_ These record operations that modify the configuration or metadata of resources. For instance,
  they include create, modify, or delete operations.
- _Data Access logs:_ These logs record API calls that read the configuration or metadata of resources, as well as
  user-driven API calls that create, modify, or read user-provided resource data.
- _System Event logs:_ These logs record Google Cloud administrative actions that modify configuration or metadata of
  resources.

#### Security logs

Security logs capture events related to the security of the system. In Google Cloud, security-related entries are often
also present in audit logs. For instance, logs of access control management, authentication events, or activities with
potential security implications are recorded.

In addition, dedicated security services like Google Cloud's Security Command Center and Google Cloud Armor also produce
security logs, providing information about threats and attacks on your Google Cloud environment.

### Cloud Trace

**GCPs Cloud Trace** allows you to analyze the latency of your application's operations. It automatically collects
latency data from applications running in Google Cloud, and presents it on the Cloud Console. This feature helps you
identify performance bottlenecks and troubleshoot issues in your applications.

#### Key features

- **Automatic Trace Collection:** By including the Cloud Trace SDK in your application, latency information about your
  application is automatically collected, whether it's running on Google Cloud, another cloud platform, or on-premise
  environments.
- **Latency Reporting and Analysis:** Cloud Trace provides latency reports and detailed traces. A latency report
  contains a set of latency distributions which show you how many requests are falling into each latency bucket. Trace
  details depict the time it takes for an application to service requests, breaking down latency into its
  sub-components.
- **Performance Insights:** Cloud Trace enables you to understand how requests propagate through your application. It
  does this by creating a visual representation of latency data with charts and traces, including showing you detailed
  views of individual traces and comparing latency information from different time periods to identify performance
  regressions.
- **Integration with other Google Cloud Services:** Cloud Trace is well-integrated with other Google Cloud services like
  Google Cloud Logging, Google Cloud Monitoring and Google Cloud Debugger. This enables you to correlate trace data with
  log entries and metrics, creating a cohesive picture of your application's behavior and performance.

### Cloud Profiler

**GCPs Cloud Profiler** provides a statistical, low-overhead way to collect and visualize the CPU usage and memory
allocation in your applications. The goal of Cloud Profiler is to help developers understand the performance
characteristics of their applications, discover potential bottlenecks, and optimize resource usage.

#### Key benefits

- **Low Overhead Profiling:** Cloud Profiler introduces minimal overhead (typically less than 1%), making it safe to be
  used in production environments. This ensures that the profiling process does not significantly affect your
  application's performance.
- **Flame Graphs:** Cloud Profiler presents the collected data in the form of an interactive Flame Graph. This
  visualization makes it easy to see which functions use the most resources and how these functions call each other.
- **Language Support:** Cloud Profiler supports a range of popular programming languages used in cloud applications,
  including Java, Python, Go, and Node.js.
- **Integration with Google Cloud Environment:** Cloud Profiler is designed to work with other parts of Google Cloud,
  like Google Cloud Run, App Engine, Compute Engine, and Google Kubernetes Engine (GKE). It is also possible to use it
  with applications running outside of Google Cloud.
- **Comparison Across Profiles:** Cloud Profiler allows you to compare profiles from different times or different
  versions of your service. This makes it easier to identify and understand the impact of changes to code or
  configuration on your application's performance.

### Error reporting

**GCPs Error Reporting** is a tool that aggregates and displays errors produced in your running cloud services. It
provides real-time monitoring and troubleshooting of deployed services, helping you to understand, reproduce, and fix
issues faster.

#### Key benefits

- **Real-time Error Monitoring:** Cloud Error Reporting automatically groups and displays errors happening in your
  application in real-time, providing developers with instant awareness of issues as they arise.
- **Automatic Grouping and Prioritization:** The tool can intelligently group similar errors together, reducing noise
  and prioritizing issues that need attention. It displays error count and frequency to help you prioritize the most
  critical issues.
- **Detailed Error Context:** Cloud Error Reporting provides detailed reports for each error group, including stack
  traces, frequency of occurrence, affected user counts, first and last seen timestamps, and even links directly to the
  related code in the Google Cloud Source Repositories.
- **Alerting and Notifications:** You can configure Cloud Error Reporting to send email notifications when new errors
  are detected. This helps maintain awareness of new issues affecting the application.
- **Integration:** It smoothly integrates with other Google Cloud services. For instance, you can click through errors
  to related logs in Cloud Logging or associated incidents in Cloud Monitoring.
- **Language and Platform Support:** Cloud Error Reporting supports several popular programming languages such as Java,
  Python, JavaScript, and Go. It can be used with applications running on Google Cloud Run, App Engine, Compute Engine,
  Google Kubernetes Engine (GKE), and even outside of Google Cloud.
