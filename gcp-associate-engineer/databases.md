## Databases

GCP provides a wide variety of different data persistence services that include relational and NoSQL databases, services
that can handle huge amounts of data (> PBs), im-memory databases like Redis.

**_OLTP (Online Transaction Processing)_** refers to systems and databases optimized for managing transactional workloads, characterized by a high volume of small, atomic operations such as inserts, updates, and deletes. These systems prioritize data integrity, concurrency, and fast response times for day-to-day operational tasks like order processing, banking transactions, or inventory management.

**_OLAP (Online Analytical Processing)_**, on the other hand, focuses on complex queries and aggregations over large datasets to support business intelligence, reporting, and data analysis. OLAP systems are designed to efficiently handle read-heavy workloads involving historical or aggregated data, often employing techniques like dimensional modeling, pre-aggregation, and parallel processing to enable rapid analysis of multidimensional data for decision-making purposes.

### Disk databases

A disk database, also known as a disk-based database, is a type of database management system that primarily stores and
retrieves data from computer hard disk drives or solid-state drives (SSDs). In disk databases, data is organized into
files or pages on the physical storage medium, and operations such as reading, writing, and updating involve disk I/O.
This approach allows for the persistence of large volumes of data beyond the limits of main memory, but it can also
introduce latency due to the relatively slower access times of disk drives compared to RAM. Disk databases often employ
techniques like indexing, caching, and query optimization to mitigate these performance challenges.

**CloudSQL** is Google's fully managed relational database service that takes care of the heavy lifting of database
administration. It supports MySQL, PostgreSQL, and SQL Server, making it a versatile choice for many applications. With
Cloud SQL, you don't have to worry about backups, replication, patches, or updates – Google handles all of that for you.
This service shines in scenarios where you need a traditional relational database with ACID compliance, such as for
content management systems, e-commerce platforms, or any application built on common web frameworks. While Cloud SQL
does offer high availability and failover support, it primarily scales vertically, meaning you increase resources (CPU,
RAM) rather than distributing data across multiple machines.

**Cloud Spanner** is a globally distributed, horizontally scalable relational database with strong consistency. It's
like having your cake and eating it too – the familiarity of SQL and ACID transactions combined with the scalability
usually associated with NoSQL databases. Spanner can handle millions of operations per second while maintaining
synchronous replication across regions and even continents. This makes it invaluable for applications where data
consistency is paramount, such as in financial services, global inventory systems, or telecom. However, this power comes
at a price, both literally and in terms of complexity, so Spanner is often overkill for smaller applications.

**Cloud BigTable** is a powerhouse for handling massive workloads with consistent low latency. Bigtable is append-only
and is particularly well-suited for time-series data, marketing data, financial trading information, and Internet of
Things (IoT) data. It can scale seamlessly to hundreds of petabytes without downtime, making it ideal for applications
that need to ingest and analyze huge volumes of data in real-time. Unlike Spanner or Cloud SQL, Bigtable doesn't support
SQL queries or multi-row transactions. Instead, it's optimized for key-based access patterns, which contributes to its
impressive performance.

**Cloud Firestore** is a flexible, scalable document database, excelling at keeping data in sync across web and mobile
clients. Its real-time listeners can propagate changes to all connected devices in milliseconds, which is perfect for
collaborative tools, chat applications, or live gaming leaderboards. Firestore also offers strong consistency, offline
support to reduce latency, and declarative security rules that make access control more manageable. While it may not
handle the sheer volume of data that Bigtable can, Firestore's strength lies in its ability to simplify building
responsive, data-driven applications.

**BigQuery** is a serverless data warehouse designed for analytics at a massive scale. BigQuery separates storage and
compute, allowing you to run SQL queries over petabytes of data without managing any infrastructure. This pay-per-query
model means you're only charged for the storage you use and the queries you run, making it cost-effective for
large-scale data analysis. BigQuery goes beyond just storage and querying; it includes features like BigQuery ML, which
lets you create and execute machine learning models using SQL, and easy data sharing capabilities. It's the go-to
solution for data analysts and scientists who need to draw insights from vast datasets, power business intelligence
dashboards, or run complex reporting jobs.

### In-memory databases

An in-memory database (IMDB) is a type of database management system that primarily relies on main memory (RAM) for data
storage, rather than disk drives. By keeping data in RAM, IMDBs can provide extremely fast data access and manipulation,
with response times often measured in microseconds. This approach eliminates the latency associated with disk I/O,
making in-memory databases particularly well-suited for applications requiring real-time processing, such as trading
systems, gaming, telecom, and session management. However, because RAM is volatile, in-memory databases may use
techniques like snapshots, transaction logging, or non-volatile RAM to ensure data durability in case of power loss or
system crashes.

**Cloud Memorystore** is GCP's fully managed in-memory data store service, compatible with the Redis and Memcached
protocols. For Redis, it provides a scalable, secure, and highly available implementation with features like automatic
failover, data persistence, and IAM integration. Memorystore for Redis is often used for caching, session management,
gaming leaderboards, and real-time analytics. It supports instances up to 300 GB and offers sub-millisecond latency. The
Memcached version is a simpler, pure caching solution without persistence or replication, ideal for basic caching needs.
Memorystore abstracts away the complexity of deploying, managing, and scaling in-memory stores, allowing developers to
focus on building applications.

**AlloyDB for PostgreSQL**, while primarily a disk-based database, includes an in-memory columnar accelerator that
significantly boosts analytical query performance. This feature dynamically moves frequently accessed columns into RAM
and compresses them, enabling fast scans and aggregations common in OLAP workloads. By combining this in-memory
acceleration with PostgreSQL's robust transactional capabilities, AlloyDB aims to support both OLTP and OLAP in a single
system. However, it's important to note that AlloyDB is not a pure in-memory database like Memorystore; rather, it uses
in-memory techniques to enhance performance for specific query patterns while still relying on disk storage for data
persistence.
