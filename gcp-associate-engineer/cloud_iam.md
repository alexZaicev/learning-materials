## Cloud Identity Access Management (IAM)

Google Cloud IAM service is a critical component of the GCP that enables secure and granular control over access to
resources withing the cloud environment.

#### Key features and aspects

- **Principals and roles**:
    - **_Principal_** is the entity that can be granted access, such as user, service account, or Google group.
    - **_Role_** defines a collection of permissions that a principal can have, such viewing, creating, or deleting.
- **Role-Based Access Control (RBAC)**: allows administrators to grant specific roles to principals at various levels of
  the resource hierarchy (organization, folder, project, or individual resource). This granular control ensures that
  access is granted based on the principle of least privilege.
- **Resource Hierarchy**: GCP resources are organized in a hierarchical structure, with organizations at the top,
  followed by folders, projects, and individual resources (e.g., virtual machines, storage buckets). Permissions granted
  at a higher level in the hierarchy are inherited by resources at lower levels, but can be overridden or restricted as
  needed.
- **Predefined and Custom Roles**: GCP provides a set of predefined roles (e.g., Editor, Viewer, Owner) that cover
  common use cases. However, administrators can also create custom roles with specific combinations of permissions to
  meet their unique requirements.
- **Service Accounts**: Service accounts are special types of principals used by applications or services to
  authenticate and access GCP resources programmatically. They can be granted roles and permissions, just like user
  accounts, enabling secure access for applications and automation processes.
- **Auditing and Logging**: Cloud IAM provides detailed audit logs that capture changes to IAM policies, roles, and
  permissions. These logs can be integrated with other monitoring and security tools for comprehensive auditing and
  compliance purposes.
- **Integration with Other GCP Services**: Cloud IAM integrates seamlessly with other GCP services, enabling consistent
  access control and security across the entire cloud environment. For example, IAM policies can control access to Cloud
  Storage buckets, BigQuery datasets, or Cloud Functions.
- **API and Automation**: Cloud IAM provides APIs and automation tools, allowing developers to programmatically manage
  and update IAM policies, roles, and permissions as part of their software development and deployment processes.

#### Access control list (ACLs)

An Access Control List (ACL) in Cloud IAM is a set of rules that define the permissions granted to specific entities (
users, groups, or service accounts) on individual cloud resources or collections of resources. Each ACL entry binds a
principal (the entity) to a role (a collection of permissions), allowing granular control over who can perform what
actions on which resources within the GCP. ACLs can be applied at various levels of the resource hierarchy, with
permissions inherited from higher levels unless overridden by more specific rules lower in the hierarchy.

#### Service accounts

A service account is a special type of account in Google Cloud Platform (GCP) that is designed to represent a non-human
identity, such as an application or a workload running on Google Cloud. Service accounts are used to authenticate and
authorize access to Google Cloud resources and services programmatically.

The primary purpose of service accounts is to enable secure and controlled access to GCP resources by applications,
services, or automated processes without the need for user intervention or manual authentication. This is particularly
useful in scenarios where applications or services need to interact with other GCP resources, such as reading or writing
data to Cloud Storage, accessing databases, or deploying resources using the Google Cloud APIs.

**Types of SAa**:

- **_Google-managed service accounts_**: These are service accounts that are automatically created and managed by Google
  Cloud services or applications. For example, when you create a Google Compute Engine instance, a Google-managed
  service account is automatically created and assigned to the instance. This service account allows the instance to
  authenticate with other GCP services, such as accessing Cloud Storage or logging data to Cloud Logging.
- **_User-managed service accounts_**: These are service accounts that are created, owned, and managed by users or
  administrators within their GCP projects. User-managed service accounts can be assigned custom roles and permissions,
  allowing granular control over the resources and actions they can access or perform. This type of service account is
  commonly used for custom applications, scripts, or automation tasks that need to interact with GCP resources.

Service accounts can be granted specific roles and permissions using the Identity and Access Management (IAM) service in
GCP, following the principle of least privilege. This ensures that service accounts have only the necessary permissions
to perform their intended tasks, reducing the risk of unauthorized access or data breaches.

Additionally, service accounts can be associated with various authentication mechanisms, such as service account keys (
used for server-to-server authentication) or OAuth 2.0 access tokens (used for client-server authentication). These
authentication mechanisms enable secure and auditable access to GCP resources by applications or services running both
inside and outside the Google Cloud environment.
