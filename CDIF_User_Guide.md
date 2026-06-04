# CDIF — Configuration & Pipeline User Guide

**Cloud Platform Data Ingestion Framework**

A guide to creating and managing Credential Stores, Connections, and Pipelines using SQL or the Config Admin UI.

| | |
|---|---|
| **Author** | Prashant Sukhe |
| **Date** | April 27, 2026 |
| **Version** | 2.0 |
| **Classification** | Internal — US Bank |
| **Team** | Finance Cloud Platform — Data Ingestion |

> **Schema note:** In dev, tables live in the `public` schema as described in this guide. In UAT, all the tables are in the `fcpadmin` schema.

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Understanding the JSON Configuration](#2-understanding-the-json-configuration)
3. [Credential Stores — Fields & SQL](#3-credential-stores--fields--sql)
4. [Connections — Fields & SQL](#4-connections--fields--sql)
5. [Pipelines — Fields & SQL](#5-pipelines--fields--sql)
6. [End-to-End Walkthrough](#6-end-to-end-walkthrough)
7. [Config Admin UI](#7-config-admin-ui)
8. [Troubleshooting](#8-troubleshooting)
9. [Known Limitations](#9-known-limitations)

---

## 1. Architecture Overview

The CDIF framework stores all configuration in three PostgreSQL tables inside the Aurora config database. Each table row is conceptually a JSON object — each column is a JSON key. If a field is absent or NULL, the framework treats it as blank or not applicable.

```
 Credential Store          Connection              Pipeline
 (Vault settings)  ───▶    (endpoint details) ───▶ (data transfer)

 Credential Store — referenced by name in Connection's 'credential_store' field
 Connection       — referenced by name in Pipeline's 'source' and 'target' fields
```

The framework supports all 16 source → target combinations:

| Source ↓ \ Target → | Database | S3 | SFTP | VM |
|---|:---:|:---:|:---:|:---:|
| Database | ✓ | ✓ | ✓ | ✓ |
| S3       | ✓ | ✓ | ✓ | ✓ |
| SFTP     | ✓ | ✓ | ✓ | ✓ |
| VM       | ✓ | ✓ | ✓ | ✓ |

---

## 2. Understanding the JSON Configuration

Each of the three configuration entities (Credential Store, Connection, Pipeline) is a JSON object. When stored in the Aurora database, each JSON key becomes a table column.

> 💡 Only the keys listed as **MANDATORY** must be present. All other keys are optional — if a key is absent, the framework treats the value as blank/null/not needed. You only include the keys relevant to your connection type.

For example, an S3 connection does not need `hostname`, `port`, or `database` — it uses `bucket_arn` and `assume_role_arn` instead. Simply omit the fields you don't need.

There are two ways to create configuration entries:

- **SQL INSERT** — directly into the Aurora PostgreSQL tables (shown in this guide)
- **Config Admin UI** — the Streamlit web app at `http://fcp.config` (see Section 7)

---

## 3. Credential Stores — Fields & SQL

A credential store defines where secrets live. It tells the framework how to authenticate to HashiCorp Vault or AWS Secrets Manager.

### 3.1 Field Reference

| Field | Required? | Description |
|---|---|---|
| `credential_store_id` | MANDATORY | Unique integer ID (primary key) |
| `name` | MANDATORY | Unique name — this is how connections reference this store |
| `vault_location` | MANDATORY | Backend type: `hashicorp_vault` or `aws_secrets_manager` |
| `vault_url` | Optional | Vault server URL (required for `hashicorp_vault`) |
| `vault_role_id_env_var` | Optional | Env var name holding Vault AppRole Role ID |
| `vault_secret_id_env_var` | Optional | Env var name holding Vault AppRole Secret ID |
| `vault_namespace` | Optional | Vault namespace (e.g. `10641`) |

> 🔑 You do NOT store actual Vault Role IDs or Secret IDs here — only the environment variable names. The actual values are injected at deploy time via GitLab CI/CD.

### 3.2 JSON Structure

```json
{
  "credential_store_id": 1,
  "name": "hashicorp_value_namespace_10641",
  "vault_location": "hashicorp_vault",
  "vault_url": "https://hashicorp-vault-test.us.bank-dns.com/",
  "vault_role_id_env_var": "HASHICORPS_ROLE_ID",
  "vault_secret_id_env_var": "HASHICORPS_SECRET_ID",
  "vault_namespace": "10641"
}
```

### 3.3 SQL: Create

```sql
INSERT INTO public.fcp_credential_store (
    credential_store_id, name, vault_location, vault_url,
    vault_role_id_env_var, vault_secret_id_env_var, vault_namespace
) VALUES (
    2,
    'hashicorp_vault_namespace_11397',
    'hashicorp_vault',
    'https://hashicorp-vault-test.us.bank-dns.com/',
    'HASHICORPS_ROLE_ID',
    'HASHICORPS_SECRET_ID',
    '11397'
);
```

### 3.4 SQL: List / Update / Delete

```sql
-- List all credential stores
SELECT * FROM public.fcp_credential_store ORDER BY credential_store_id;

-- Update
UPDATE public.fcp_credential_store
SET vault_url = 'https://hashicorp-vault-prod.us.bank-dns.com/'
WHERE name = 'hashicorp_vault_namespace_11397';

-- Delete (check no connections reference it first!)
SELECT name FROM public.fcp_connections
WHERE credential_store = 'hashicorp_vault_namespace_11397';

DELETE FROM public.fcp_credential_store WHERE credential_store_id = 2;
```

---

## 4. Connections — Fields & SQL

A connection defines a source or target endpoint. The framework supports four connection types: `database`, `s3`, `sftp`, and `vm`. Include only the fields relevant to your connection type — omit the rest.

### 4.1 Field Reference

| Field | Required? | Applies To | Description |
|---|---|---|---|
| `connection_id` | MANDATORY | All | Unique integer ID (primary key) |
| `name` | MANDATORY | All | Unique name — pipelines reference this |
| `type` | MANDATORY | All | `database`, `s3`, `sftp`, or `vm` |
| `hostname` | MANDATORY\* | DB, SFTP, VM | Host/endpoint (\*S3 uses `bucket_arn` instead) |
| `credential_store` | Optional | DB, SFTP, VM | Name of the credential store to use |
| `port` | Optional | DB, SFTP, VM | Port number (defaults: PG=5432, ORA=1521, SFTP=22) |
| `database` | Optional | DB only | Database/service name |
| `db_driver` | Optional | DB only | `postgresql`, `oracle`, `mssql`, or `mysql` |
| `auth_type` | Optional | All | `sql_auth` (default), `ad_auth`, or `iam_role` |
| `credential_path` | Optional | DB, SFTP, VM | Vault secret path for credentials |
| `bucket_arn` | Optional | S3 only | S3 bucket ARN (replaces `hostname` for S3) |
| `assume_role_arn` | Optional | S3 only | IAM role ARN to assume for S3 access |
| `s3_addressing_style` | Optional | S3 only | `path` or `virtual` |

> 🪣 For S3 connections with `iam_role` auth, you don't need `credential_store` or `credential_path`. The pod assumes the IAM role via EKS Pod Identity — no Vault lookup needed.

### 4.2 Database Connection (PostgreSQL)

```json
{
  "connection_id": 2,
  "name": "AWS_292085144669_AURORA_icsetldevdb_dev",
  "type": "database",
  "credential_store": "hashicorp_value_namespace_10641",
  "hostname": "ics-11397-src-dev-db.cluster-c1o6isuoctp6.us-east-2.rds.amazonaws.com",
  "port": 5432,
  "database": "icsetldevdb",
  "db_driver": "postgresql",
  "auth_type": "sql_auth",
  "credential_path": "secret/dev/CDIF_srcdb"
}
```

```sql
INSERT INTO public.fcp_connections (
    connection_id, name, type, credential_store,
    hostname, port, database, db_driver, auth_type, credential_path
) VALUES (
    2, 'AWS_292085144669_AURORA_icsetldevdb_dev', 'database',
    'hashicorp_value_namespace_10641',
    'ics-11397-src-dev-db.cluster-c1o6isuoctp6.us-east-2.rds.amazonaws.com',
    5432, 'icsetldevdb', 'postgresql', 'sql_auth', 'secret/dev/CDIF_srcdb'
);
```

### 4.3 Database Connection (Oracle)

```sql
INSERT INTO public.fcp_connections (
    connection_id, name, type, credential_store,
    hostname, port, database, db_driver, auth_type, credential_path
) VALUES (
    1, 'AWS_604245832754_RDS_FCPFDWDV', 'database',
    'hashicorp_value_namespace_10641',
    'ip-10-87-109-150.us-east-2.compute.internal',
    1521, 'FCPFDWDV', 'oracle', 'sql_auth', '/secret/dev/CDIF_FDW'
);
```

### 4.4 Database Connection (SQL Server — AD Auth)

```sql
INSERT INTO public.fcp_connections (
    connection_id, name, type, credential_store,
    hostname, port, database, db_driver, auth_type, credential_path
) VALUES (
    5, 'onprem_SQL_SERVER_RMDM_db_dev', 'database',
    'hashicorp_value_namespace_10641',
    '10.127.200.214', 49001, 'RMDM', 'mssql', 'ad_auth',
    'secret/dev/CDIF_RMDM'
);
```

> 🛡️ For `ad_auth`, the Vault secret must store credentials in `DOMAIN\\username` format. The framework runs `kinit` to obtain a Kerberos TGT before connecting.

### 4.5 S3 Connection (IAM Role Auth)

```json
{
  "connection_id": 4,
  "name": "AWS_292085144669_S3_dev",
  "type": "s3",
  "auth_type": "iam_role",
  "bucket_arn": "arn:aws:s3:::292085144669-us-east-2-ics-11397-dev-s3",
  "assume_role_arn": "arn:aws:iam::292085144669:role/fcp-11397-dev-eks-s3-access-role",
  "s3_addressing_style": "path"
}
```

```sql
INSERT INTO public.fcp_connections (
    connection_id, name, type, auth_type,
    bucket_arn, assume_role_arn, s3_addressing_style
) VALUES (
    4, 'AWS_292085144669_S3_dev', 's3', 'iam_role',
    'arn:aws:s3:::292085144669-us-east-2-ics-11397-dev-s3',
    'arn:aws:iam::292085144669:role/fcp-11397-dev-eks-s3-access-role',
    'path'
);
```

### 4.6 SFTP Connection

```sql
INSERT INTO public.fcp_connections (
    connection_id, name, type, credential_store,
    hostname, port, auth_type, credential_path
) VALUES (
    3, 'CDIF_Sterling_Gateway_sftp', 'sftp',
    'hashicorp_value_namespace_10641',
    'filegateway-test.us.bank-dns.com', 20022,
    'sql_auth', '/secret/dev/CDIF_Sterling_Gateway'
);
```

### 4.7 Update / Delete Connections

```sql
-- Update hostname
UPDATE public.fcp_connections
SET hostname = 'new-cluster.us-east-2.rds.amazonaws.com'
WHERE name = 'AWS_292085144669_AURORA_icsetldevdb_dev';

-- Delete (ensure no pipelines reference it first!)
SELECT name FROM public.fcp_pipelines
WHERE source = 'MY_CONNECTION' OR target = 'MY_CONNECTION';

DELETE FROM public.fcp_connections WHERE connection_id = 99;
```

---

## 5. Pipelines — Fields & SQL

A pipeline defines a data transfer from one connection (source) to another (target). Include only the fields relevant to your source/target types.

### 5.1 Field Reference

| Field | Required? | Description |
|---|---|---|
| `pipeline_id` | MANDATORY | Unique integer ID (primary key) |
| `name` | Recommended | Unique pipeline name (used for `depends_on` references and logging) |
| `source` | MANDATORY | Source connection name — must match `fcp_connections.name` |
| `target` | MANDATORY | Target connection name — must match `fcp_connections.name` |
| `status` | Optional | Blank or `START` = eligible to run; `COMPLETED`/`FAILED`/`DISABLED` = skipped |
| `run_mode` | Optional | `full` (truncate + reload) or `delta` (append). Default: `delta` |
| `car_id` | Optional | Change Authorization Record ID |
| `source_query` | Optional\* | SQL SELECT query — required when source is a database |
| `src_file_path` | Optional\* | File path or glob pattern — required when source is S3/SFTP/VM |
| `target_schema` | Optional\* | Target DB schema — required when target is a database |
| `target_table` | Optional\* | Target DB table — required when target is a database |
| `target_file_name` | Optional\* | Target file path — required when target is S3/SFTP/VM. Supports `{datetime}` |
| `depends_on` | Optional | Name of another pipeline that must succeed first |
| `dedup_tracking_table` | Optional | Table name for file deduplication tracking |
| `connection_timeout` | Optional | Timeout in seconds (default: 30) |
| `retry_count` | Optional | Retry attempts on failure (default: 3) |

> 📋 Fields marked `Optional*` are conditionally required based on source/target type. For example: `source_query` is needed for DB sources; `src_file_path` for file sources.

### 5.2 Which Fields Do I Need?

| Scenario | Required Fields | Example |
|---|---|---|
| DB → DB | `source_query`, `target_schema`, `target_table` | Oracle → Aurora |
| DB → S3/SFTP/VM | `source_query`, `target_file_name` | Aurora → S3 export |
| S3/SFTP/VM → DB | `src_file_path`, `target_schema`, `target_table` | SFTP CSV → Aurora |
| S3/SFTP/VM → S3/SFTP/VM | `src_file_path`, `target_file_name` | S3 archive/copy |

### 5.3 DB-to-DB Pipeline

Extract from Oracle, load into PostgreSQL:

```json
{
  "pipeline_id": 1,
  "name": "Oracle_to_Aurora_IP_ACL",
  "car_id": "11397",
  "status": "START",
  "run_mode": "full",
  "source": "AWS_604245832754_RDS_FCPFDWDV",
  "target": "AWS_292085144669_AURORA_icsetldevdb_dev",
  "source_query": "SELECT SERVICE_NAME, HOST FROM DBSFWUSER.IP_ACL",
  "target_schema": "public",
  "target_table": "test_FDW"
}
```

```sql
INSERT INTO public.fcp_pipelines (
    pipeline_id, name, car_id, status, run_mode,
    source, target, source_query, target_schema, target_table
) VALUES (
    1, 'Oracle_to_Aurora_IP_ACL', '11397', 'START', 'full',
    'AWS_604245832754_RDS_FCPFDWDV',
    'AWS_292085144669_AURORA_icsetldevdb_dev',
    'SELECT SERVICE_NAME, HOST FROM DBSFWUSER.IP_ACL',
    'public', 'test_FDW'
);
```

### 5.4 SFTP-to-DB Pipeline

```sql
INSERT INTO public.fcp_pipelines (
    pipeline_id, name, car_id, status, run_mode,
    source, target, src_file_path, target_schema, target_table
) VALUES (
    2, 'SFTP_to_Aurora_bbq_data', '11397', 'START', 'full',
    'CDIF_Sterling_Gateway_sftp',
    'AWS_292085144669_AURORA_icsetldevdb_dev',
    '/Inbox/test_bbq*',
    'public', 'test_bbq'
);
```

> 📂 Glob patterns (e.g. `/Inbox/test_bbq*`) are supported for file sources. All matching files are ingested.

### 5.5 S3-to-S3 Pipeline (Archive/Copy)

```sql
INSERT INTO public.fcp_pipelines (
    pipeline_id, name, car_id, status, run_mode,
    source, target, src_file_path, target_file_name
) VALUES (
    4, 'S3_archive_employees', '11397', 'START', 'full',
    'AWS_292085144669_S3_dev',
    'AWS_292085144669_S3_dev',
    'Source/employees.csv',
    'archive/employees_{datetime}.csv'
);
```

> ⏰ `{datetime}` is replaced at runtime with the current timestamp (e.g. `20260427_143022`).

### 5.6 DB-to-S3 Export Pipeline

```sql
INSERT INTO public.fcp_pipelines (
    pipeline_id, name, car_id, status, run_mode,
    source, target, source_query, target_file_name
) VALUES (
    6, 'Aurora_to_S3_export_config', '10641', 'START', 'full',
    'AWS_292085144669_AURORA_icsetldevdb_dev',
    'AWS_292085144669_S3_dev',
    'SELECT config_data FROM public.fcp_credential_store',
    'config/credential_store_{datetime}.json'
);
```

### 5.7 SQL Server (AD Auth) to Aurora Pipeline

```sql
INSERT INTO public.fcp_pipelines (
    pipeline_id, name, car_id, status, run_mode,
    source, target, source_query, target_schema, target_table
) VALUES (
    5, 'MSSQL_RMDM_to_Aurora', '11397', 'START', 'full',
    'onprem_SQL_SERVER_RMDM_db_dev',
    'AWS_292085144669_AURORA_icsetldevdb_dev',
    'SELECT [P1C5Id],[UploadId],[LoanNum] FROM [DataConversion].[P1C5]',
    'public', 'test_RMDM'
);
```

### 5.8 Pipeline with Dependency Chain

```sql
-- Pipeline B waits for Pipeline A to complete first
INSERT INTO public.fcp_pipelines (
    pipeline_id, name, car_id, status, run_mode,
    source, target, source_query, target_schema, target_table,
    depends_on
) VALUES (
    20, 'Transform_after_load', '11397', 'START', 'full',
    'AWS_292085144669_AURORA_icsetldevdb_dev',
    'AWS_292085144669_AURORA_icsetldevdb_dev',
    'SELECT id, amount * 1.1 AS adjusted FROM public.raw_data',
    'public', 'transformed_data',
    'S3_to_Aurora_load_raw'   -- must match name of dependency pipeline
);
```

### 5.9 Pipeline Status Management

```sql
-- List all pipelines
SELECT pipeline_id, name, status, source, target FROM public.fcp_pipelines
ORDER BY pipeline_id;

-- Mark as eligible to run
UPDATE public.fcp_pipelines SET status = 'START' WHERE pipeline_id = 1;

-- Reset a completed pipeline for re-run
UPDATE public.fcp_pipelines SET status = '' WHERE pipeline_id = 1;

-- Disable a pipeline
UPDATE public.fcp_pipelines SET status = 'DISABLED' WHERE pipeline_id = 1;

-- Delete a pipeline
DELETE FROM public.fcp_pipelines WHERE pipeline_id = 99;
```

### 5.10 Status Values Reference

| Status | Meaning | Framework Behavior |
|---|---|---|
| (blank) | Eligible to run | Picked up on next CronJob execution |
| `START` | Eligible to run | Picked up on next CronJob execution |
| `COMPLETED` | Finished successfully | Skipped — reset to blank/START to re-run |
| `FAILED` | Finished with errors | Skipped — reset to blank/START to retry |
| `DISABLED` | Manually disabled | Skipped by orchestrator indefinitely |

---

## 6. End-to-End Walkthrough

This example sets up a new Oracle-to-Aurora ingestion from scratch.

### Step 1 — Check existing credential stores

```sql
SELECT credential_store_id, name, vault_namespace
FROM public.fcp_credential_store;
```

If namespace `10641` already exists, reuse it. Otherwise create one:

### Step 2 — Create credential store (if needed)

```sql
INSERT INTO public.fcp_credential_store (
    credential_store_id, name, vault_location, vault_url,
    vault_role_id_env_var, vault_secret_id_env_var, vault_namespace
) VALUES (
    3, 'hashicorp_vault_ns_myapp', 'hashicorp_vault',
    'https://hashicorp-vault-test.us.bank-dns.com/',
    'HASHICORPS_ROLE_ID', 'HASHICORPS_SECRET_ID', '10641'
);
```

### Step 3 — Create the Vault secret

In HashiCorp Vault (UI or CLI) under the appropriate namespace:

```bash
vault kv put secret/dev/CDIF_NEW_ORACLE \
    username="myuser" password="mypassword"
```

### Step 4 — Create source connection

```sql
INSERT INTO public.fcp_connections (
    connection_id, name, type, credential_store,
    hostname, port, database, db_driver, auth_type, credential_path
) VALUES (
    11, 'ORA_NEWDB_dev', 'database', 'hashicorp_vault_ns_myapp',
    'oracle-host.us-east-2.compute.internal', 1521,
    'NEWDB', 'oracle', 'sql_auth', 'secret/dev/CDIF_NEW_ORACLE'
);
```

### Step 5 — Create the pipeline

```sql
INSERT INTO public.fcp_pipelines (
    pipeline_id, name, car_id, status, run_mode,
    source, target, source_query, target_schema, target_table
) VALUES (
    18, 'ORA_NEWDB_to_Aurora_customers', '11397', 'START', 'full',
    'ORA_NEWDB_dev',
    'AWS_292085144669_AURORA_icsetldevdb_dev',
    'SELECT CUSTOMER_ID, NAME, EMAIL FROM APPUSER.CUSTOMERS',
    'public', 'customers_staging'
);
```

### Step 6 — What happens next

The framework CronJob runs on schedule and automatically:

1. Reads `fcp_pipelines` — finds entries with `status = 'START'` or blank
2. Resolves source/target from `fcp_connections` by name
3. Fetches credentials from Vault using the credential store config
4. Creates the appropriate extractor (DB/S3/SFTP/VM) and loader
5. Executes extract → load data flow
6. Updates pipeline status to `COMPLETED` or `FAILED`

---

## 7. Config Admin UI

Instead of running SQL directly, you can use the CDIF Config Admin UI — a Streamlit web application accessible at `http://fcp.config`.

The UI provides three tabs:

- **Credential Stores** — full CRUD (Create, Read, Update, Delete)
- **Connections** — full CRUD
- **Pipelines** — read-only view of all pipeline configurations

Login credentials are configured via `CDIF_UI_USER` / `CDIF_UI_PASSWORD` environment variables injected at deploy time.

---

## 8. Troubleshooting

### Common Issues

| Problem | Cause | Fix |
|---|---|---|
| Pipeline stays in `START` | CronJob is suspended | Set `suspend: false` in CronJob values |
| Unknown `credential_store` | Name mismatch (case-sensitive) | Verify connection's `credential_store` matches `fcp_credential_store.name` exactly |
| Connection 'X' not found | Pipeline source/target typo | Check `fcp_connections.name` matches exactly |
| Vault auth fails | Expired AppRole credentials | Renew `HASHICORPS_ROLE_ID` / `SECRET_ID` in CI/CD |
| `credential_path` empty | Secret doesn't exist in Vault | Create secret under correct Vault namespace |
| S3 access denied | IAM role lacks permissions | Verify `assume_role_arn` has S3 read/write policy |
| AD auth fails (MSSQL) | Kerberos TGT not obtained | Check `KRB5_PRINCIPAL` and password in Vault |
| Duplicate mapping name | Two pipelines have same name | Ensure each pipeline has a unique name |

### Diagnostic Queries

```sql
-- Find pipelines referencing a connection
SELECT name, source, target, status FROM public.fcp_pipelines
WHERE source = 'MY_CONNECTION' OR target = 'MY_CONNECTION';

-- Find connections using a credential store
SELECT name, type, hostname FROM public.fcp_connections
WHERE credential_store = 'hashicorp_value_namespace_10641';

-- Show all failed pipelines
SELECT pipeline_id, name, source, target FROM public.fcp_pipelines
WHERE status = 'FAILED';

-- Reset all failed pipelines
UPDATE public.fcp_pipelines SET status = 'START' WHERE status = 'FAILED';

-- Find next available IDs
SELECT COALESCE(MAX(credential_store_id), 0) + 1 FROM public.fcp_credential_store;
SELECT COALESCE(MAX(connection_id), 0) + 1 FROM public.fcp_connections;
SELECT COALESCE(MAX(pipeline_id), 0) + 1 FROM public.fcp_pipelines;
```

---

## 9. Known Limitations

> ⚠️ **Config Admin UI is Work in Progress**
> The Streamlit-based Config Admin UI (`http://fcp.config`) is currently under active development. Some features may not be fully functional. For production use, SQL commands against the Aurora database are the recommended approach.

> ⚠️ **Shared Aurora Database**
> The framework currently uses the Iconic ETL Aurora DB (`icsetldevdb`) for storing configuration. As a next step, we will migrate to a dedicated Aurora database for the ingestion framework. This migration will NOT change the user experience — table names, SQL commands, and the Config UI will remain identical.

> ⚠️ **SSO Authentication — Handled Separately**
> Single Sign-On (SSO) integration for the Config Admin UI is not yet implemented. Authentication is currently handled via simple username/password credentials injected through environment variables. SSO integration will be addressed separately.

> ⚠️ **No Real-Time Pipeline Monitoring in UI**
> The Config Admin UI does not show real-time pipeline execution status. To monitor running pipelines, check DataDog logs or query the `fcp_pipelines` table directly for status updates.

> ⚠️ **Single CronJob Schedule**
> All pipelines share the same CronJob schedule. If you need different schedules for different pipelines, use the `status` field to control which pipelines run (set `START` before the desired run, `DISABLED` otherwise).

> ⚠️ **No Schema Auto-Creation**
> Target database tables must exist before the pipeline runs. The framework will create the table automatically if it doesn't exist (using pandas `to_sql`), but column types may not be optimal. For production, pre-create tables with proper schemas.

> ⚠️ **File Format Detection**
> For file-based sources (S3, SFTP, VM), the framework auto-detects format by file extension (`.csv`, `.json`, `.parquet`, `.xlsx`). Ensure source files use standard extensions.

---

*U.S. Bank | Finance Cloud Platform | CDIF User Guide v2.0 | Internal Use Only*
