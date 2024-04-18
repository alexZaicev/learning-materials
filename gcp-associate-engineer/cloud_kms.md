## Cloud Ket Management Service (KMS)

Cloud KMS is a service for managing cryptographic keys for the cloud services, allowing to generate, use, rotate, and
destroy `AES256`, `RSA 2048`, `RSA 3072`, `RSA 4096`, `EC P256`, and `EC P384` cryptographic keys.

#### Key features

- **Hierarchy and organization**: implements a hierarchical key managements approach with multiple levels, including
  _Key Rings_, _CryptoKeys_, and _CryptoKeyVersions_, enabling the organization and fine-grained access control of
  encryption keys.
- **Access control**: integration with IAM and Audit logs for key access control, permissions managements, and auditing.
- **Geographic location**: keys can be stored in any location, for meeting compliance and regulatory requirements.
- **Integration**: integration with other GCP service, allowing encrypting data at rest.
- **Protect sensitive data**: Cloud KMS provides protection of sensitive data, such as Personal Identifiable
  Information (PII), financial data, and service account keys that are used in business.
- **Encryption and decryption**: allows to encrypt/decrypt data using cryptographic keys, and provides usage of digital
  signatures and certificates.
- **Compliance**: Cloud KMS is compliant with various industry standards like FIPS 140-2 Level 3, PCI DSS, HIPAA, and
  more.

#### Data at rest

Cloud KMS can provide encryption keys to encrypt sensitive data that is stored in a persistent state, such as database,
storage disks, or backup tapes. If an unauthorized party attempts to access this data, they will only see encrypted
values that are meaningless without the decryption key.

#### Data in motion

Data in motion/transit is automatically encrypted by Google Cloud, however, Cloud KMS can add additional layer of
security by generating and managing keys for client-side or server-side encryption when data is transmitted over a
network. This can help secure the transmission of sensitive data, ensuring that if the data is intercepted, it cannot be
read without the appropriate decryption key.

#### Data in use

Securing data in use is a complex task that often combines techniques, such
as [secure enclave](https://www.anjuna.io/resources/what-is-a-secure-enclave) or memory encryption. Cloud KMS provides
applications an ability to encrypt/decrypt data internally when dealing with in-memory storage.
