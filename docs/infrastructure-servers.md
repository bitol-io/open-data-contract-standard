---
title: "Infrastructures & Servers"
description: "This section describes server structures, properties and types."
---

<!--
Copyright 2026 The Bitol Contributors
SPDX-License-Identifier: Apache-2.0
-->

# Infrastructure & Servers

The `servers` element describes where the data protected by this data contract is *physically* located. That metadata helps to know where the data is so that a data consumer can discover the data and a platform engineer can automate access.

An entry in `servers` describes a single dataset on a specific environment and a specific technology. The `servers` element can contain multiple servers, each with its own configuration.

The typical ways of using the top level `servers` element are as follows:

* **Single Server:** The data contract protects a specific dataset at a specific location. *Example:* a CSV file on an SFTP server.
* **Multiple Environments:** The data contract makes sure that the data is protected in all environments. *Example:* a data product with data in a **dev**(elopment), UAT, and **prod**(uction) environment on Databricks.
* **Different Technologies:** The data contract makes sure that regardless of the offered technology, it still holds. *Example:* a data product offers its data in a Kafka topic and in a BigQuery table that should have the same structure and content.
* **Different Technologies and Multiple Environments:** The data contract makes sure that regardless of the offered technology and environment, it still holds. *Example:* a data product offers its data in a Kafka topic and in a BigQuery table that should have the same structure and content in **dev**(elopment), UAT, and **prod**(uction).

[Back to TOC](README.md)

## General Server Structure

Each server in the schema has the following structure:

```yaml
servers:
  - id: my_awesome_server
    server: my-server-name
    type: <server-type>
    description: <server-description>
    environment: <server-environment>
    <server-type-specific-fields> # according to the server type, see below
    roles:
      - <role-details>
    customProperties:
      - <custom-properties>
```

### Common Server Properties

| Key              | Type   | UX label          | Required | Description                                                                                                                                                                                                                                                                                                                       |
| ---------------- | ------ | ----------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| description      | string | Description       | No       | Description of the server.                                                                                                                                                                                                                                                                                                        |
| environment      | string | Environment       | No       | Environment of the server. Examples includes: prod, preprod, dev, uat.                                                                                                                                                                                                                                                            |
| id               | string | ID                | No       | A unique identifier used to reduce the risk of collisions, such as a UUID.                                                                                                                                                                                                                                                        |
| roles            | array  | Roles             | No       | List of roles that have access to the server. Check [roles](./roles.md) section for more details.                                                                                                                                                                                                                                 |
| server           | string | Server            | Yes      | Identifier of the server.                                                                                                                                                                                                                                                                                                         |
| type             | string | Type              | Yes      | Type of the server. Can be one of: api, athena, azure, bigquery, clickhouse, cloudsql, custom, databricks, db2, denodo, dremio, duckdb, exasol, glue, hive, impala, informix, kafka, kinesis, local, mysql, oracle, postgres, postgresql, presto, pubsub, redshift, s3, sftp, snowflake, sqlserver, synapse, trino, vertica, zen. |
| customProperties | array  | Custom Properties | No       | Custom properties that are not part of the standard.                                                                                                                                                                                                                                                                              |

## Specific Server Properties

Each server type can be customized with different properties such as `host`, `port`, `database`, and `schema`, depending on the server technology in use. Refer to the specific documentation for each server type for additional configurations.

## Specific Server Properties

If your server is not in the list, please use [custom](#custom-server) and suggest it as an improvement. Possible values for `type` are:

### API Server

An API server describes data that is exposed through a network API rather than served from a database or file storage. The endpoint a consumer calls is identified by its URL.

| Key          | Type   | UX Label | Required | Description    |
| ------------ | ------ | -------- | -------- | -------------- |
| **location** | string | Location | Yes      | URL to the API |

### Amazon Athena Server

[Amazon Athena](https://docs.aws.amazon.com/athena/latest/ug/what-is.html) is an interactive query service that makes it easy to analyze data directly in Amazon Simple Storage Service (Amazon S3) using standard SQL. With a few actions in the AWS Management Console, you can point Athena at your data stored in Amazon S3 and begin using standard SQL to run ad-hoc queries and get results in seconds.

| Key        | Type   | UX Label          | Required | Description                                                                                                                                                      |
| ---------- | ------ | ----------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| catalog    | string | Catalog           | No       | Identify the name of the Data Source, also referred to as a Catalog.                                                                                             |
| regionName | string | Region Name       | No       | The region your AWS account uses.                                                                                                                                |
| schema     | string | Schema            | Yes      | Identify the schema in the data source in which your tables exist.                                                                                               |
| stagingDir | string | Staging Directory | No       | Amazon Athena automatically stores query results and metadata information for each query that runs in a query result location that you can specify in Amazon S3. |
| workgroup  | string | Workgroup         | No       | The Athena workgroup to use. Workgroups can enforce query result location and other client-side settings via the 'Override client-side settings' option.         |

### Azure Server

[Azure Blob Storage](https://azure.microsoft.com/en-us/products/storage/blobs) and [Azure Data Lake Storage (ADLS)](https://azure.microsoft.com/en-us/products/storage/data-lake-storage) are the Microsoft Azure object storage services for unstructured data and large-scale analytics workloads.

| Key       | Type   | UX Label  | Required | Description                                                                                           |
| --------- | ------ | --------- | -------- | ----------------------------------------------------------------------------------------------------- |
| delimiter | string | Delimiter | No       | Only for format = json. How multiple json documents are delimited within one file                     |
| encoding  | string | Encoding  | No       | Expected character encoding of the payload, e.g. UTF-8, ISO-8859-1, ASCII, UTF-16. Defaults to UTF-8. |
| format    | string | Format    | Yes      | File format.                                                                                          |
| location  | string | Location  | Yes      | Fully qualified path to Azure Blob Storage or Azure Data Lake Storage (ADLS), supports globs.         |

### Google BigQuery

[BigQuery](https://cloud.google.com/bigquery) is a fully managed, AI-ready data analytics platform that helps you maximize value from your data and is designed to be multi-engine, multi-format, and multi-cloud.

| Key     | Type   | UX Label | Required | Description                                   |
| ------- | ------ | -------- | -------- | --------------------------------------------- |
| dataset | string | Dataset  | Yes      | The GCP dataset name.                         |
| project | string | Project  | Yes      | The Google Cloud Platform (GCP) project name. |

### ClickHouse Server

[ClickHouse](https://clickhouse.com/) is an open-source column-oriented database management system that allows generating analytical data reports in real-time.

| Key      | Type    | UX Label | Required | Description                        |
| -------- | ------- | -------- | -------- | ---------------------------------- |
| database | string  | Database | Yes      | The name of the database.          |
| host     | string  | Host     | Yes      | The host of the ClickHouse server. |
| port     | integer | Port     | Yes      | The port to the ClickHouse server. |

### Google Cloud SQL

[Google Cloud SQL](https://cloud.google.com/sql) is a fully managed, cost-effective relational database service for PostgreSQL, MySQL, and SQL Server.

| Key      | Type    | UX Label | Required | Description                              |
| -------- | ------- | -------- | -------- | ---------------------------------------- |
| database | string  | Database | Yes      | The name of the database.                |
| host     | string  | Host     | Yes      | The host of the Google Cloud SQL server. |
| port     | integer | Port     | Yes      | The port of the Google Cloud SQL server. |
| schema   | string  | Schema   | Yes      | The name of the schema.                  |

### Databricks Server

[Databricks](https://www.databricks.com/) is a cloud-based data platform, built on Apache Spark, that unifies data warehousing and data lakes under the lakehouse architecture.

| Key     | Type   | UX Label | Required | Description                           |
| ------- | ------ | -------- | -------- | ------------------------------------- |
| catalog | string | Catalog  | Yes      | The name of the Hive or Unity catalog |
| host    | string | Host     | No       | The Databricks host                   |
| schema  | string | Schema   | Yes      | The schema name in the catalog        |

### IBM Db2 Server

[IBM Db2](https://www.ibm.com/products/db2) is a family of relational database management systems for transactional and analytical workloads, available both on cloud and on-premises.

| Key      | Type    | UX Label | Required | Description                     |
| -------- | ------- | -------- | -------- | ------------------------------- |
| database | string  | Database | Yes      | The name of the database.       |
| host     | string  | Host     | Yes      | The host of the IBM DB2 server. |
| port     | integer | Port     | Yes      | The port of the IBM DB2 server. |
| schema   | string  | Schema   | No       | The name of the schema.         |

### Denodo Server

[Denodo](https://www.denodo.com/) is a data virtualization platform that provides unified, real-time access to data spread across disparate sources, without replicating it.

| Key      | Type    | UX Label | Required | Description                    |
| -------- | ------- | -------- | -------- | ------------------------------ |
| database | string  | Database | No       | The name of the database.      |
| host     | string  | Host     | Yes      | The host of the Denodo server. |
| port     | integer | Port     | Yes      | The port of the Denodo server. |

### Dremio Server

[Dremio](https://www.dremio.com/) is a lakehouse platform that runs SQL queries directly against data lake storage, built on Apache Arrow and Apache Iceberg.

| Key    | Type    | UX Label | Required | Description                    |
| ------ | ------- | -------- | -------- | ------------------------------ |
| host   | string  | Host     | Yes      | The host of the Dremio server. |
| port   | integer | Port     | Yes      | The port of the Dremio server. |
| schema | string  | Schema   | No       | The name of the schema.        |

### DuckDB Server

[DuckDB](https://duckdb.org/) supports a feature-rich SQL dialect complemented with deep integrations into client APIs.

| Key      | Type   | UX Label | Required | Description                   |
| -------- | ------ | -------- | -------- | ----------------------------- |
| database | string | Database | Yes      | Path to duckdb database file. |
| schema   | string | Schema   | No       | The name of the schema.       |

### Exasol

[Exasol](https://www.exasol.com/) is an in-memory, massively parallel processing (MPP) analytics database used as an enterprise data warehouse. Added in ODCS v3.2.0 ([RFC 0058](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0058-exasol-server-type.md)).

An Exasol cluster runs a single database and the schema is the namespace, so there is no `database` field.

| Key    | Type    | UX Label | Required | Description                                                                            |
| ------ | ------- | -------- | -------- | -------------------------------------------------------------------------------------- |
| host   | string  | Host     | Yes      | Host of the Exasol server. May be a cluster connection range, e.g. `n11..14.acme.com`. |
| port   | integer | Port     | No       | Port of the Exasol server. Defaults to 8563.                                           |
| schema | string  | Schema   | No       | Name of the schema.                                                                    |

### Amazon Glue

[AWS Glue](https://aws.amazon.com/glue/) is a serverless data integration service. Its Data Catalog holds the table definitions and schema metadata describing data stored in Amazon S3 and other sources.

| Key      | Type   | UX Label | Required | Description                                                                                           |
| -------- | ------ | -------- | -------- | ----------------------------------------------------------------------------------------------------- |
| account  | string | Account  | Yes      | The AWS Glue account                                                                                  |
| database | string | Database | Yes      | The AWS Glue database name                                                                            |
| encoding | string | Encoding | No       | Expected character encoding of the payload, e.g. UTF-8, ISO-8859-1, ASCII, UTF-16. Defaults to UTF-8. |
| format   | string | Format   | No       | The format of the files                                                                               |
| location | string | Location | No       | The AWS S3 path. Must be in the form of a URL.                                                        |

### Hive

[Apache Hive](https://hive.apache.org/) is a distributed, fault-tolerant data warehouse system that enables analytics at massive scale. Built on top of Apache Hadoop, Hive allows users to read, write, and manage petabytes of data using SQL-like queries through HiveQL, with native support for cloud storage systems and enterprise-grade security features.

| Key      | Type    | UX Label | Required | Description                                     |
| -------- | ------- | -------- | -------- | ----------------------------------------------- |
| database | string  | Database | Yes      | The name of the Hive database.                  |
| host     | string  | Host     | Yes      | The host to the Hive server.                    |
| port     | integer | Port     | No       | The port to the Hive server. Defaults to 10000. |

### Apache Iceberg

[Apache Iceberg](https://iceberg.apache.org/) is an open table format for large analytic datasets, accessed through the standardized Iceberg REST catalog API (Polaris, S3 Tables, Nessie, Unity Catalog, Glue, etc.). Added in ODCS v3.2.0 ([RFC 0049](https://github.com/bitol-io/tsc/blob/main/rfcs/approved/odcs-v3.2.0/0049-iceberg-server-type.md)).

| Key        | Type   | UX Label    | Required | Description                                                                                                 |
| ---------- | ------ | ----------- | -------- | ----------------------------------------------------------------------------------------------------------- |
| catalog    | string | Catalog     | Yes      | Catalog name as registered in the query engine or catalog service (e.g. `my_catalog`).                      |
| catalogUrl | string | Catalog URL | Yes      | URL of the Iceberg compatible REST catalog service (Polaris, S3 Tables, Nessie, Unity Catalog, Glue, etc.). |
| namespace  | string | Namespace   | No       | Dot-separated namespace path within the catalog (e.g. `db.schema` or just `db`).                            |
| warehouse  | string | Warehouse   | No       | Base storage location of the warehouse (e.g. `s3://my-bucket/warehouse/`).                                  |

### Apache Impala

[Apache Impala](https://impala.apache.org/) is a massively parallel processing (MPP) SQL query engine for data stored in Apache Hadoop clusters. Impala provides high-performance, low-latency SQL queries on data stored in HDFS and Apache HBase, enabling interactive exploration and analytics without data movement or transformation.

| Key      | Type    | UX Label | Required | Description                                       |
| -------- | ------- | -------- | -------- | ------------------------------------------------- |
| database | string  | Database | Yes      | The name of the Impala database.                  |
| host     | string  | Host     | Yes      | The host to the Impala server.                    |
| port     | integer | Port     | No       | The port to the Impala server. Defaults to 21050. |

### HCL Informix and IBM Informix

[HCL Informix](https://www.hcl-software.com/informix) and [IBM Informix](https://www.ibm.com/products/informix) are high performance, always-on, highly scalable and easily embeddable enterprise-class databases optimized for the most demanding transactional and analytics workloads. As object-relational engines, HCL Informix and IBM Informix seamlessly integrate the best of relational and object-oriented capabilities, enabling the flexible modeling of complex data structures and relationships.

| Key      | Type    | UX Label | Required | Description                                                             |
| -------- | ------- | -------- | -------- | ----------------------------------------------------------------------- |
| database | string  | Database | Yes      | The name of the database.                                               |
| host     | string  | Host     | Yes      | The host to the HCL Informix and IBM Informix server.                   |
| port     | integer | Port     | No       | The port to the HCL Informix and IBM Informix server. Defaults to 9088. |

### Kafka Server

[Apache Kafka](https://kafka.apache.org/) is an open-source distributed event streaming platform used for high-performance data pipelines, streaming analytics, and event-driven applications.

| Key      | Type   | UX Label | Required | Description                                                                                           |
| -------- | ------ | -------- | -------- | ----------------------------------------------------------------------------------------------------- |
| encoding | string | Encoding | No       | Expected character encoding of the payload, e.g. UTF-8, ISO-8859-1, ASCII, UTF-16. Defaults to UTF-8. |
| format   | string | Format   | No       | The format of the messages.                                                                           |
| host     | string | Host     | Yes      | The bootstrap server of the kafka cluster.                                                            |

### Amazon Kinesis

[Amazon Kinesis Data Streams](https://aws.amazon.com/kinesis/) is a serverless streaming data service for collecting, processing, and analyzing large streams of records in real time.

| Key      | Type   | UX Label | Required | Description                                                                                           |
| -------- | ------ | -------- | -------- | ----------------------------------------------------------------------------------------------------- |
| encoding | string | Encoding | No       | Expected character encoding of the payload, e.g. UTF-8, ISO-8859-1, ASCII, UTF-16. Defaults to UTF-8. |
| format   | string | Format   | No       | The format of the record                                                                              |
| region   | string | Region   | No       | AWS region.                                                                                           |
| stream   | string | Stream   | Yes      | The name of the Kinesis data stream.                                                                  |

### Local Files

A local server describes data stored as one or more files on the local file system, addressed by a relative or absolute path. It is typically used for development, testing, and small datasets.

| Key      | Type   | UX Label | Required | Description                                                                                           |
| -------- | ------ | -------- | -------- | ----------------------------------------------------------------------------------------------------- |
| encoding | string | Encoding | No       | Expected character encoding of the payload, e.g. UTF-8, ISO-8859-1, ASCII, UTF-16. Defaults to UTF-8. |
| format   | string | Format   | Yes      | The format of the file(s)                                                                             |
| path     | string | Path     | Yes      | The relative or absolute path to the data file(s).                                                    |

### MySQL Server

[MySQL](https://www.mysql.com/) is an open-source relational database management system, widely used for transactional and web applications.

| Key      | Type    | UX Label | Required | Description                                     |
| -------- | ------- | -------- | -------- | ----------------------------------------------- |
| database | string  | Database | Yes      | The name of the database.                       |
| host     | string  | Host     | Yes      | The host of the MySql server.                   |
| port     | integer | Port     | No       | The port of the MySql server. Defaults to 3306. |

### Oracle

[Oracle Database](https://www.oracle.com/database/) is a multi-model relational database management system used for transactional and analytical enterprise workloads. Clients connect to a named service rather than directly to a database.

| Key         | Type    | UX Label     | Required | Description                    |
| ----------- | ------- | ------------ | -------- | ------------------------------ |
| host        | string  | Host         | Yes      | The host to the Oracle server  |
| port        | integer | Port         | Yes      | The port to the Oracle server. |
| serviceName | string  | Service Name | Yes      | The name of the service.       |

### PostgreSQL

[PostgreSQL](https://www.postgresql.org/) is a powerful, open source object-relational database system with over 35 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance.

| Key      | Type    | UX Label | Required | Description                                          |
| -------- | ------- | -------- | -------- | ---------------------------------------------------- |
| database | string  | Database | Yes      | The name of the database.                            |
| host     | string  | Host     | Yes      | The host to the PostgreSQL server                    |
| port     | integer | Port     | No       | The port to the PostgreSQL server. Defaults to 5432. |
| schema   | string  | Schema   | No       | The name of the schema in the database.              |

### Presto Server

[Presto](https://prestodb.io/) is an open-source distributed SQL query engine for running interactive analytic queries against data sources of any size, from gigabytes to petabytes.

| Key     | Type   | UX Label | Required | Description                   |
| ------- | ------ | -------- | -------- | ----------------------------- |
| catalog | string | Catalog  | No       | The name of the catalog.      |
| host    | string | Host     | Yes      | The host to the Presto server |
| schema  | string | Schema   | No       | The name of the schema.       |

### Google Pub/Sub

[Google Cloud](https://cloud.google.com/pubsub) service to Ingest events for streaming into BigQuery, data lakes or operational databases.

| Key     | Type   | UX Label | Required | Description           |
| ------- | ------ | -------- | -------- | --------------------- |
| project | string | Project  | Yes      | The GCP project name. |

### Amazon Redshift Server

[Amazon Redshift](https://aws.amazon.com/redshift/) is a power data driven decisions with the best price-performance cloud data warehouse.

| Key      | Type   | UX Label | Required | Description                               |
| -------- | ------ | -------- | -------- | ----------------------------------------- |
| account  | string | Account  | No       | The account used by the server.           |
| database | string | Database | Yes      | The name of the database.                 |
| host     | string | Host     | No       | An optional string describing the server. |
| region   | string | Region   | No       | AWS region of Redshift server.            |
| schema   | string | Schema   | Yes      | The name of the schema.                   |

### Amazon S3 Server and Compatible Servers

[Amazon Simple Storage Service (Amazon S3)](https://aws.amazon.com/s3/) is an object storage service offering industry-leading scalability, data availability, security, and performance. Millions of customers of all sizes and industries store, manage, analyze, and protect any amount of data for virtually any use case, such as data lakes, cloud-native applications, and mobile apps. Other vendors have implemented a compatible implementation of S3.

| Key         | Type   | UX Label     | Required | Description                                                                                           |
| ----------- | ------ | ------------ | -------- | ----------------------------------------------------------------------------------------------------- |
| delimiter   | string | Delimiter    | No       | Only for format = json. How multiple json documents are delimited within one file                     |
| encoding    | string | Encoding     | No       | Expected character encoding of the payload, e.g. UTF-8, ISO-8859-1, ASCII, UTF-16. Defaults to UTF-8. |
| endpointUrl | string | Endpoint URL | No       | The server endpoint for S3-compatible servers.                                                        |
| format      | string | Format       | No       | File format.                                                                                          |
| location    | string | Location     | Yes      | S3 URL, starting with `s3://`                                                                         |

### SAP HANA

[SAP HANA](https://www.sap.com/products/technology-platform/hana.html) is an in-memory, column-oriented relational database used as an enterprise data platform.

| Key      | Type    | UX Label | Required | Description                    |
| -------- | ------- | -------- | -------- | ------------------------------ |
| host     | string  | Host     | Yes      | Host of the HANA server.       |
| port     | integer | Port     | No       | Port of the HANA server.       |
| database | string  | Database | No       | Name of the database (tenant). |
| schema   | string  | Schema   | No       | Name of the schema.            |

### SFTP Server

Secure File Transfer Protocol (SFTP) is a network protocol that enables secure and encrypted file transfers between a client and a server.

| Key       | Type   | UX Label  | Required | Description                                                                                           |
| --------- | ------ | --------- | -------- | ----------------------------------------------------------------------------------------------------- |
| delimiter | string | Delimiter | No       | Only for format = json. How multiple json documents are delimited within one file                     |
| encoding  | string | Encoding  | No       | Expected character encoding of the payload, e.g. UTF-8, ISO-8859-1, ASCII, UTF-16. Defaults to UTF-8. |
| format    | string | Format    | No       | File format.                                                                                          |
| location  | string | Location  | Yes      | SFTP URL, starting with `sftp://`. The URL should include the port number.                            |

### Snowflake

[Snowflake](https://www.snowflake.com/) is a fully managed cloud data platform that separates storage from compute, where compute is provided by virtual warehouses that can be sized and scaled independently.

| Key       | Type    | UX Label  | Required | Description                                                                 |
| --------- | ------- | --------- | -------- | --------------------------------------------------------------------------- |
| account   | string  | Account   | Yes      | The Snowflake account used by the server.                                   |
| database  | string  | Database  | Yes      | The name of the database.                                                   |
| host      | string  | Host      | Yes      | The host to the Snowflake server                                            |
| port      | integer | Port      | Yes      | The port to the Snowflake server.                                           |
| schema    | string  | Schema    | Yes      | The name of the schema.                                                     |
| warehouse | string  | Warehouse | Yes      | The name of the cluster of resources that is a Snowflake virtual warehouse. |

### Microsoft SQL Server

[Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) is a proprietary relational database management system developed by Microsoft.

| Key      | Type    | UX Label | Required | Description                                        |
| -------- | ------- | -------- | -------- | -------------------------------------------------- |
| database | string  | Database | Yes      | The name of the database.                          |
| host     | string  | Host     | Yes      | The host to the database server                    |
| port     | integer | Port     | No       | The port to the database server. Defaults to 1433. |
| schema   | string  | Schema   | Yes      | The name of the schema in the database.            |

### Synapse Server

[Azure Synapse Analytics](https://azure.microsoft.com/en-us/products/synapse-analytics) is the Microsoft Azure analytics service that brings together enterprise data warehousing and big data analytics.

| Key      | Type    | UX Label | Required | Description                     |
| -------- | ------- | -------- | -------- | ------------------------------- |
| database | string  | Database | Yes      | The name of the database.       |
| host     | string  | Host     | Yes      | The host of the Synapse server. |
| port     | integer | Port     | Yes      | The port of the Synapse server. |

### Trino Server

[Trino](https://trino.io/) is an open-source distributed SQL query engine designed to query large datasets across one or more heterogeneous data sources.

| Key     | Type    | UX Label | Required | Description                             |
| ------- | ------- | -------- | -------- | --------------------------------------- |
| catalog | string  | Catalog  | Yes      | The name of the catalog.                |
| host    | string  | Host     | Yes      | The Trino host URL.                     |
| port    | integer | Port     | Yes      | The Trino port.                         |
| schema  | string  | Schema   | Yes      | The name of the schema in the database. |

### Vertica Server

[Vertica](https://docs.vertica.com/) is a column-oriented, massively parallel processing (MPP) analytical database for large-scale data warehousing.

| Key      | Type    | UX Label | Required | Description                     |
| -------- | ------- | -------- | -------- | ------------------------------- |
| database | string  | Database | Yes      | The name of the database.       |
| host     | string  | Host     | Yes      | The host of the Vertica server. |
| port     | integer | Port     | Yes      | The port of the Vertica server. |
| schema   | string  | Schema   | Yes      | The name of the schema.         |

### Actian Zen Server

Actian Zen (formerly Btrieve, later named Pervasive PSQL until version 13) is an ACID-compliant, zero-DBA, embedded, nano-footprint, multi-model, Multi-Platform database management system (DBMS).

| Key      | Type    | UX Label | Required | Description                                        |
| -------- | ------- | -------- | -------- | -------------------------------------------------- |
| database | string  | Database | Yes      | Database name to connect to on the Zen server.     |
| host     | string  | Host     | Yes      | Hostname or IP address of the Zen server.          |
| port     | integer | Port     | No       | Zen server SQL connections port. Defaults to 1583. |

### Custom Server

A custom server describes any technology that does not have a dedicated type in ODCS yet. It accepts the union of the properties defined by the other server types, so connection details can still be expressed in a structured way.

| Key         | Type    | UX Label          | Required | Description                                                                                           |
| ----------- | ------- | ----------------- | -------- | ----------------------------------------------------------------------------------------------------- |
| account     | string  | Account           | No       | Account used by the server.                                                                           |
| catalog     | string  | Catalog           | No       | Name of the catalog.                                                                                  |
| database    | string  | Database          | No       | Name of the database.                                                                                 |
| dataset     | string  | Dataset           | No       | Name of the dataset.                                                                                  |
| delimiter   | string  | Delimiter         | No       | Delimiter.                                                                                            |
| encoding    | string  | Encoding          | No       | Expected character encoding of the payload, e.g. UTF-8, ISO-8859-1, ASCII, UTF-16. Defaults to UTF-8. |
| endpointUrl | string  | Endpoint URL      | No       | Server endpoint.                                                                                      |
| format      | string  | Format            | No       | File format.                                                                                          |
| host        | string  | Host              | No       | Host name or IP address.                                                                              |
| location    | string  | Location          | No       | A URL to a location.                                                                                  |
| path        | string  | Path              | No       | Relative or absolute path to the data file(s).                                                        |
| port        | integer | Port              | No       | Port to the server. No default value is assumed for custom servers.                                   |
| project     | string  | Project           | No       | Project name.                                                                                         |
| region      | string  | Region            | No       | Cloud region.                                                                                         |
| regionName  | string  | Region Name       | No       | Region name.                                                                                          |
| schema      | string  | Schema            | No       | Name of the schema.                                                                                   |
| serviceName | string  | Service Name      | No       | Name of the service.                                                                                  |
| stagingDir  | string  | Staging Directory | No       | Staging directory.                                                                                    |
| stream      | string  | Stream            | No       | Name of the data stream.                                                                              |
| warehouse   | string  | Warehouse         | No       | Name of the cluster or warehouse.                                                                     |

If you need another property, use [custom properties](./custom-other-properties.md).

[Back to TOC](README.md)
