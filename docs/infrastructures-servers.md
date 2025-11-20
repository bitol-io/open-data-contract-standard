---
title: "Infrastructures & Servers"
description: "This section describes server structures, properties and types."
---

# Infrastructure & Servers

The `servers` element describes where the data protected by this data contract is *physically* located. That metadata helps to know where the data is so that a data consumer can discover the data and a platform engineer can automate access.

An entry in `servers` describes a single dataset on a specific environment and a specific technology. The `servers` element can contain multiple servers, each with its own configuration.

The typical ways of using the top level `servers` element are as follows:

* **Single Server:** The data contract protects a specific dataset at a specific location. *Example:* a CSV file on an SFTP server.
* **Multiple Environments:** The data contract makes sure that the data is protected in all environments. *Example:* a data product with data in a dev(elopment), UAT, and prod(uction) environment on Databricks.
* **Different Technologies:** The data contract makes sure that regardless of the offered technology, it still holds. *Example:* a data product offers its data in a Kafka topic and in a BigQuery table that should have the same structure and content.
* **Different Technologies and Multiple Environments:** The data contract makes sure that regardless of the offered technology and environment, it still holds. *Example:* a data product offers its data in a Kafka topic and in a BigQuery table that should have the same structure and content in dev(elopment), UAT, and prod(uction).


## Table of Contents <!-- omit in toc -->
- [General Server Structure](#general-server-structure)
  - [Common Server Properties](#common-server-properties)
- [Specific Server Properties](#specific-server-properties)
- [Specific Server Properties \& Types](#specific-server-properties--types)
  - [API Server](#api-server)
  - [Amazon Athena Server](#amazon-athena-server)
  - [Azure Server](#azure-server)
  - [Google BigQuery](#google-bigquery)
  - [ClickHouse Server](#clickhouse-server)
  - [Google Cloud SQL](#google-cloud-sql)
  - [Databricks Server](#databricks-server)
  - [IBM Db2 Server](#ibm-db2-server)
  - [Denodo Server](#denodo-server)
  - [Dremio Server](#dremio-server)
  - [DuckDB Server](#duckdb-server)
  - [Amazon Glue](#amazon-glue)
  - [Hive](#hive)
  - [IBM Informix and HCL Informix](#ibm-informix-and-hcl-informix)
  - [Kafka Server](#kafka-server)
  - [Amazon Kinesis](#amazon-kinesis)
  - [Local Files](#local-files)
  - [MySQL Server](#mysql-server)
  - [Oracle](#oracle)
  - [PostgreSQL](#postgresql)
  - [Presto Server](#presto-server)
  - [Google Pub/Sub](#google-pubsub)
  - [Amazon Redshift Server](#amazon-redshift-server)
  - [Amazon S3 Server and Compatible Servers](#amazon-s3-server-and-compatible-servers)
  - [SFTP Server](#sftp-server)
  - [Snowflake](#snowflake)
  - [Microsoft SQL Server](#microsoft-sql-server)
  - [Synapse Server](#synapse-server)
  - [Trino Server](#trino-server)
  - [Vertica Server](#vertica-server)
  - [Custom Server](#custom-server)



## General Server Structure

Each server in the schema has the following structure:

```yaml
servers:
  - server: my-server-name
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

| Key              | UX label          | Required | Description                                                                                                                                                                                                                                                                                                    |
|------------------|-------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| server           | Server            | Yes      | Identifier of the server.                                                                                                                                                                                                                                                                                      |
| type             | Type              | Yes      | Type of the server. Can be one of: api, athena, azure, bigquery, clickhouse, cloudsql, custom, databricks, db2, denodo, dremio, duckdb, glue, hive, informix, kafka, kinesis, local, mysql, oracle, postgres, postgresql, presto, pubsub, redshift, s3, sftp, snowflake, sqlserver, synapse, trino, vertica.   |
| description      | Description       | No       | Description of the server.                                                                                                                                                                                                                                                                                     |
| environment      | Environment       | No       | Environment of the server. Examples includes: prod, preprod, dev, uat.                                                                                                                                                                                                                                         |
| roles            | Roles             | No       | List of roles that have access to the server. Check [roles](./roles.md) section for more details.                                                                                                                                                                                                                  |
| customProperties | Custom Properties | No       | Custom properties that are not part of the standard.                                                                                                                                                                                                                                                           |

## Specific Server Properties

Each server type can be customized with different properties such as `host`, `port`, `database`, and `schema`, depending on the server technology in use. Refer to the specific documentation for each server type for additional configurations.

## Specific Server Properties & Types

If your server is not in the list, please use [custom](#custom-server) and suggest it as an improvement. Possible values for `type` are:

### API Server

| Key            | UX Label   | Required   | Description                                                                                                                                                      |
|----------------|------------|------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **location**   | Location   | Yes        | URL to the API                                                                                                                                                   |

### Amazon Athena Server

[Amazon Athena](https://docs.aws.amazon.com/athena/latest/ug/what-is.html) is an interactive query service that makes it easy to analyze data directly in Amazon Simple Storage Service (Amazon S3) using standard SQL. With a few actions in the AWS Management Console, you can point Athena at your data stored in Amazon S3 and begin using standard SQL to run ad-hoc queries and get results in seconds.

| Key        | UX Label          | Required | Description                                                                                                                                                      |
|------------|-------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| schema     | Schema            | Yes      | Identify the schema in the data source in which your tables exist.                                                                                               |
| stagingDir | Staging Directory | No       | Amazon Athena automatically stores query results and metadata information for each query that runs in a query result location that you can specify in Amazon S3. |
| catalog    | Catalog           | No       | Identify the name of the Data Source, also referred to as a Catalog.                                                                                             |
| regionName | Region Name       | No       | The region your AWS account uses.                                                                                                                                |

### Azure Server

| Key       | UX Label  | Required | Description                                                                                   |
|-----------|-----------|----------|-----------------------------------------------------------------------------------------------|
| location  | Location  | Yes      | Fully qualified path to Azure Blob Storage or Azure Data Lake Storage (ADLS), supports globs. |
| format    | Format    | Yes      | File format.                                                                                  |
| delimiter | Delimiter | No       | Only for format = json. How multiple json documents are delimited within one file             |

### Google BigQuery

[BigQuery](https://cloud.google.com/bigquery) is a fully managed, AI-ready data analytics platform that helps you maximize value from your data and is designed to be multi-engine, multi-format, and multi-cloud.

| Key     | UX Label | Required | Description                                   |
|---------|----------|----------|-----------------------------------------------|
| project | Project  | Yes      | The Google Cloud Platform (GCP) project name. |
| dataset | Dataset  | Yes      | The GCP dataset name.                         |

### ClickHouse Server

[ClickHouse](https://clickhouse.com/) is an open-source column-oriented database management system that allows generating analytical data reports in real-time.

| Key      | UX Label | Required | Description                        |
|----------|----------|----------|------------------------------------|
| host     | Host     | Yes      | The host of the ClickHouse server. |
| port     | Port     | Yes      | The port to the ClickHouse server. |
| database | Database | Yes      | The name of the database.          |

### Google Cloud SQL

[Google Cloud SQL](https://cloud.google.com/sql) is a fully managed, cost-effective relational database service for PostgreSQL, MySQL, and SQL Server.

| Key      | UX Label | Required | Description                              |
|----------|----------|----------|------------------------------------------|
| host     | Host     | Yes      | The host of the Google Cloud SQL server. |
| port     | Port     | Yes      | The port of the Google Cloud SQL server. |
| database | Database | Yes      | The name of the database.                |
| schema   | Schema   | Yes      | The name of the schema.                  |

### Databricks Server

| Key     | UX Label | Required | Description                           |
|---------|----------|----------|---------------------------------------|
| catalog | Catalog  | Yes      | The name of the Hive or Unity catalog |
| schema  | Schema   | Yes      | The schema name in the catalog        |
| host    | Host     | No       | The Databricks host                   |

### IBM Db2 Server

| Key      | UX Label | Required | Description                     |
|----------|----------|----------|---------------------------------|
| host     | Host     | Yes      | The host of the IBM DB2 server. |
| port     | Port     | Yes      | The port of the IBM DB2 server. |
| database | Database | Yes      | The name of the database.       |
| schema   | Schema   | No       | The name of the schema.         |

### Denodo Server

| Key      | UX Label | Required | Description                    |
|----------|----------|----------|--------------------------------|
| host     | Host     | Yes      | The host of the Denodo server. |
| port     | Port     | Yes      | The port of the Denodo server. |
| database | Database | No       | The name of the database.      |

### Dremio Server

| Key    | UX Label | Required | Description                    |
|--------|----------|----------|--------------------------------|
| host   | Host     | Yes      | The host of the Dremio server. |
| port   | Port     | Yes      | The port of the Dremio server. |
| schema | Schema   | No       | The name of the schema.        |

### DuckDB Server

[DuckDB](https://duckdb.org/) supports a feature-rich SQL dialect complemented with deep integrations into client APIs.

| Key      | UX Label | Required | Description                   |
|----------|----------|----------|-------------------------------|
| database | Database | Yes      | Path to duckdb database file. |
| schema   | Schema   | No       | The name of the schema.       |

### Amazon Glue

| Key      | UX Label | Required | Description                                    |
|----------|----------|----------|------------------------------------------------|
| account  | Account  | Yes      | The AWS Glue account                           |
| database | Database | Yes      | The AWS Glue database name                     |
| location | Location | No       | The AWS S3 path. Must be in the form of a URL. |
| format   | Format   | No       | The format of the files                        |

### Hive

[Apache Hive](https://hive.apache.org/) is a distributed, fault-tolerant data warehouse system that enables analytics at massive scale. Built on top of Apache Hadoop, Hive allows users to read, write, and manage petabytes of data using SQL-like queries through HiveQL, with native support for cloud storage systems and enterprise-grade security features.

| Key          | UX Label        | Required   | Description                                     |
|--------------|-----------------|------------|-------------------------------------------------|
| host         | Host            | Yes        | The host to the Hive server.                    |
| port         | Port            | No         | The port to the Hive server. Defaults to 10000. |
| database     | Database        | Yes        | The name of the Hive database.                  |

### IBM Informix and HCL Informix

[IBM Informix](https://www.ibm.com/products/informix) is a high performance, always-on, highly scalable and easily embeddable enterprise-class database optimized for the most demanding transactional and analytics workloads. As an object-relational engine, IBM Informix seamlessly integrates the best of relational and object-oriented capabilities enabling the flexible modeling of complex data structures and relationships.

| Key          | UX Label        | Required   | Description                                                |
|--------------|-----------------|------------|------------------------------------------------------------|
| host         | Host            | Yes        | The host to the Informix server.                           |
| port         | Port            | No         | The port to the Informix server. Defaults to 9088.         |
| database     | Database        | Yes        | The name of the database.                                  |

### Kafka Server

| Key    | UX Label | Required | Description                                |
|--------|----------|----------|--------------------------------------------|
| host   | Host     | Yes      | The bootstrap server of the kafka cluster. |
| format | Format   | No       | The format of the messages.                |

### Amazon Kinesis

| Key    | UX Label | Required | Description                          |
|--------|----------|----------|--------------------------------------|
| stream | Stream   | Yes      | The name of the Kinesis data stream. |
| region | Region   | No       | AWS region.                          |
| format | Format   | No       | The format of the record             |

### Local Files

| Key    | UX Label | Required | Description                                        |
|--------|----------|----------|----------------------------------------------------|
| path   | Path     | Yes      | The relative or absolute path to the data file(s). |
| format | Format   | Yes      | The format of the file(s)                          |

### MySQL Server

| Key      | UX Label | Required | Description                                     |
|----------|----------|----------|-------------------------------------------------|
| host     | Host     | Yes      | The host of the MySql server.                   |
| port     | Port     | No       | The port of the MySql server. Defaults to 3306. |
| database | Database | Yes      | The name of the database.                       |

### Oracle

| Key         | UX Label     | Required | Description                    |
|-------------|--------------|----------|--------------------------------|
| host        | Host         | Yes      | The host to the Oracle server  |
| port        | Port         | Yes      | The port to the Oracle server. |
| serviceName | Service Name | Yes      | The name of the service.       |

### PostgreSQL

[PostgreSQL](https://www.postgresql.org/) is a powerful, open source object-relational database system with over 35 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance.

| Key      | UX Label | Required | Description                                          |
|----------|----------|----------|------------------------------------------------------|
| host     | Host     | Yes      | The host to the PostgreSQL server                    |
| port     | Port     | No       | The port to the PostgreSQL server. Defaults to 5432. |
| database | Database | Yes      | The name of the database.                            |
| schema   | Schema   | No       | The name of the schema in the database.              |

### Presto Server

| Key     | UX Label | Required | Description                   |
|---------|----------|----------|-------------------------------|
| host    | Host     | Yes      | The host to the Presto server |
| catalog | Catalog  | No       | The name of the catalog.      |
| schema  | Schema   | No       | The name of the schema.       |

### Google Pub/Sub

[Google Cloud](https://cloud.google.com/pubsub) service to Ingest events for streaming into BigQuery, data lakes or operational databases.

| Key     | UX Label | Required | Description           |
|---------|----------|----------|-----------------------|
| project | Project  | Yes      | The GCP project name. |

### Amazon Redshift Server

[Amazon Redshift](https://aws.amazon.com/redshift/) is a power data driven decisions with the best price-performance cloud data warehouse.

| Key      | UX Label | Required | Description                               |
|----------|----------|----------|-------------------------------------------|
| database | Database | Yes      | The name of the database.                 |
| schema   | Schema   | Yes      | The name of the schema.                   |
| host     | Host     | No       | An optional string describing the server. |
| region   | Region   | No       | AWS region of Redshift server.            |
| account  | Account  | No       | The account used by the server.           |

### Amazon S3 Server and Compatible Servers

[Amazon Simple Storage Service (Amazon S3)](https://aws.amazon.com/s3/) is an object storage service offering industry-leading scalability, data availability, security, and performance. Millions of customers of all sizes and industries store, manage, analyze, and protect any amount of data for virtually any use case, such as data lakes, cloud-native applications, and mobile apps. Other vendors have implemented a compatible implementation of S3.

| Key         | UX Label     | Required | Description                                                                       |
|-------------|--------------|----------|-----------------------------------------------------------------------------------|
| location    | Location     | Yes      | S3 URL, starting with `s3://`                                                     |
| endpointUrl | Endpoint URL | No       | The server endpoint for S3-compatible servers.                                    |
| format      | Format       | No       | File format.                                                                      |
| delimiter   | Delimiter    | No       | Only for format = json. How multiple json documents are delimited within one file |

### SFTP Server

Secure File Transfer Protocol (SFTP) is a network protocol that enables secure and encrypted file transfers between a client and a server.

| Key       | UX Label  | Required | Description                                                                       |
|-----------|-----------|----------|-----------------------------------------------------------------------------------|
| location  | Location  | Yes      | SFTP URL, starting with `sftp://`. The URL should include the port number.        |
| format    | Format    | No       | File format.                                                                      |
| delimiter | Delimiter | No       | Only for format = json. How multiple json documents are delimited within one file |

### Snowflake

| Key       | UX Label  | Required | Description                                                                 |
|-----------|-----------|----------|-----------------------------------------------------------------------------|
| host      | Host      | Yes      | The host to the Snowflake server                                            |
| port      | Port      | Yes      | The port to the Snowflake server.                                           |
| account   | Account   | Yes      | The Snowflake account used by the server.                                   |
| database  | Database  | Yes      | The name of the database.                                                   |
| warehouse | Warehouse | Yes      | The name of the cluster of resources that is a Snowflake virtual warehouse. |
| schema    | Schema    | Yes      | The name of the schema.                                                     |

### Microsoft SQL Server

[Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) is a proprietary relational database management system developed by Microsoft.

| Key      | UX Label | Required | Description                                        |
|----------|----------|----------|----------------------------------------------------|
| host     | Host     | Yes      | The host to the database server                    |
| port     | Port     | No       | The port to the database server. Defaults to 1433. |
| database | Database | Yes      | The name of the database.                          |
| schema   | Schema   | Yes      | The name of the schema in the database.            |

### Synapse Server

| Key      | UX Label | Required | Description                     |
|----------|----------|----------|---------------------------------|
| host     | Host     | Yes      | The host of the Synapse server. |
| port     | Port     | Yes      | The port of the Synapse server. |
| database | Database | Yes      | The name of the database.       |

### Trino Server

| Key     | UX Label | Required | Description                             |
|---------|----------|----------|-----------------------------------------|
| host    | Host     | Yes      | The Trino host URL.                     |
| port    | Port     | Yes      | The Trino port.                         |
| catalog | Catalog  | Yes      | The name of the catalog.                |
| schema  | Schema   | Yes      | The name of the schema in the database. |

### Vertica Server

| Key      | UX Label | Required | Description                     |
|----------|----------|----------|---------------------------------|
| host     | Host     | Yes      | The host of the Vertica server. |
| port     | Port     | Yes      | The port of the Vertica server. |
| database | Database | Yes      | The name of the database.       |
| schema   | Schema   | Yes      | The name of the schema.         |

### Custom Server

| Key         | UX Label          | Required | Description                                                         |
|-------------|-------------------|----------|---------------------------------------------------------------------|
| account     | Account           | No       | Account used by the server.                                         |
| catalog     | Catalog           | No       | Name of the catalog.                                                |
| database    | Database          | No       | Name of the database.                                               |
| dataset     | Dataset           | No       | Name of the dataset.                                                |
| delimiter   | Delimiter         | No       | Delimiter.                                                          |
| endpointUrl | Endpoint URL      | No       | Server endpoint.                                                    |
| format      | Format            | No       | File format.                                                        |
| host        | Host              | No       | Host name or IP address.                                            |
| location    | Location          | No       | A URL to a location.                                                |
| path        | Path              | No       | Relative or absolute path to the data file(s).                      |
| port        | Port              | No       | Port to the server. No default value is assumed for custom servers. |
| project     | Project           | No       | Project name.                                                       |
| region      | Region            | No       | Cloud region.                                                       |
| regionName  | Region Name       | No       | Region name.                                                        |
| schema      | Schema            | No       | Name of the schema.                                                 |
| serviceName | Service Name      | No       | Name of the service.                                                |
| stagingDir  | Staging Directory | No       | Staging directory.                                                  |
| stream      | Stream            | No       | Name of the data stream.                                            |
| warehouse   | Warehouse         | No       | Name of the cluster or warehouse.                                   |

If you need another property, use [custom properties](./custom-other-properties.md).
