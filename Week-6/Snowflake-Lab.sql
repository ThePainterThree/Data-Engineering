-- 1.1  Create a virtual warehouse
CREATE OR REPLACE WAREHOUSE lab_wh_patricia
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- 1.2  Create a database and schema
CREATE OR REPLACE DATABASE retail_db_patricia;
CREATE OR REPLACE SCHEMA retail_db_patricia.raw;
CREATE OR REPLACE SCHEMA retail_db_patricia.analytics;

USE WAREHOUSE lab_wh_patricia;
USE DATABASE retail_db_patricia;
USE SCHEMA raw;

-- 1.3  Explore the sample data every trial account includes
SELECT *
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
LIMIT 10;

-- 2.1  Create the target table
CREATE OR REPLACE TABLE raw.orders (
  order_id       INT,
  customer_name  STRING,
  product        STRING,
  category       STRING,
  quantity       INT,
  unit_price     NUMBER(10,2),
  order_date     DATE,
  region         STRING
);

-- 2.4  Reload the same file using COPY INTO (the production pattern)
//create an internal stage
CREATE OR REPLACE STAGE raw.orders_stage;

LIST @raw.orders_stage;

//inspect what's in the stage
CREATE OR REPLACE TABLE raw.orders_v2 LIKE raw.orders;

-- load it into a second table so you can compare
COPY INTO raw.orders_v2
FROM @raw.orders_stage
FILE_FORMAT = (
  TYPE = CSV
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
)
ON_ERROR = 'CONTINUE';

SELECT COUNT(*)
FROM raw.orders_v2;

//see which rows failed to load
SELECT *
FROM TABLE(
  VALIDATE(raw.orders_v2, JOB_ID => '_last')
);

-- 3.1 Create a VARIANT table
CREATE OR REPLACE TABLE raw.orders_json (
  data VARIANT
);

-- 3.2  Insert sample nested JSON
INSERT INTO raw.orders_json
SELECT PARSE_JSON('{
  "order_id": 1001,
  "customer": {"name": "Asha Verma", "city": "Delhi"},
  "items": [
    {"product": "Wireless Mouse", "qty": 2, "price": 799},
    {"product": "USB-C Hub", "qty": 1, "price": 1499}
  ]
}');
 
INSERT INTO raw.orders_json
SELECT PARSE_JSON('{
  "order_id": 1002,
  "customer": {"name": "Rohan Iyer", "city": "Bengaluru"},
  "items": [
    {"product": "Mechanical Keyboard", "qty": 1, "price": 3999}
  ]
}');

SELECT *
FROM raw.orders_json;
TRUNCATE TABLE raw.orders_json;

SELECT COUNT(*)
FROM raw.orders_json;

-- 3.3 Query nested fields with dot notation
SELECT
  data:order_id::INT               AS order_id,
  data:customer.name::STRING       AS customer_name,
  data:customer.city::STRING       AS city
FROM raw.orders_json;

-- 3.4  Flatten the items array into rows
SELECT
  data:order_id::INT                    AS order_id,
  data:customer.name::STRING            AS customer_name,
  f.value:product::STRING               AS product,
  f.value:qty::INT                      AS qty,
  f.value:price::NUMBER(10,2)           AS unit_price
FROM raw.orders_json,
  LATERAL FLATTEN(input => data:items) f;

-- 4.1 Build a unified line-items view
CREATE OR REPLACE VIEW analytics.v_all_line_items AS
SELECT
  order_id, customer_name, product, quantity AS qty,
  unit_price, order_date, region, 'csv' AS source
FROM raw.orders
 
UNION ALL
 
SELECT
  data:order_id::INT, data:customer.name::STRING,
  f.value:product::STRING, f.value:qty::INT,
  f.value:price::NUMBER(10,2), CURRENT_DATE(),
  data:customer.city::STRING, 'json' AS source
FROM raw.orders_json, LATERAL FLATTEN(input => data:items) f;

SELECT COUNT(*) AS row_count
FROM analytics.v_all_line_items;

-- 4.2  Aggregate revenue by region
SELECT
  region,
  SUM(qty * unit_price) AS revenue,
  COUNT(DISTINCT order_id) AS orders
FROM analytics.v_all_line_items
GROUP BY region
ORDER BY revenue DESC;

--5.1  Make a mistake on purpose DANGER ZONE
-- note the row count before
-- SELECT COUNT(*) FROM raw.orders;
 
-- accidentally wipe out a region's data
-- DELETE FROM raw.orders WHERE region = 'North';
 
--SELECT COUNT(*) FROM raw.orders;

-- 5.3  Zero-copy clone
--Cloning creates a new table that shares the same underlying micro-partitions as the source — instant, and no extra storage cost until one side changes.
CREATE OR REPLACE TABLE raw.orders_backup CLONE raw.orders;
 
-- prove it's independent: changes to the clone don't affect the original
DELETE FROM raw.orders_backup WHERE region = 'South';
SELECT COUNT(*) FROM raw.orders;         -- unaffected
SELECT COUNT(*) FROM raw.orders_backup;  -- reduced

-- Goal: Model a read-only analyst role and see how privileges cascade through Snowflake's role hierarchy.
--6.1  Create a role and grant privileges

CREATE OR REPLACE ROLE analyst_patricia;

GRANT USAGE ON WAREHOUSE lab_wh_patricia
TO ROLE analyst_patricia;

GRANT USAGE ON DATABASE retail_db_patricia
TO ROLE analyst_patricia;

GRANT USAGE ON SCHEMA retail_db_patricia.analytics
TO ROLE analyst_patricia;

GRANT SELECT ON ALL VIEWS IN SCHEMA retail_db_patricia.analytics
TO ROLE analyst_patricia;

GRANT SELECT ON FUTURE VIEWS IN SCHEMA retail_db_patricia.analytics
TO ROLE analyst_patricia;

--6.2  Assign the role to your own user and test
SELECT CURRENT_USER();

GRANT ROLE analyst_patricia
TO USER SNOWPATTI;

USE ROLE analyst_patricia;

SELECT *
FROM retail_db_patricia.analytics.v_all_line_items
LIMIT 5;

SELECT *
FROM retail_db_patricia.raw.orders;

USE ROLE analyst_patricia;
USE SECONDARY ROLES NONE;
SELECT *
FROM retail_db_patricia.raw.orders;
SHOW GRANTS TO ROLE analyst_patricia;

-- Goal: Run a nontrivial join against the TPCH sample dataset, then read the Query Profile to understand where time is spent.
--7.1  Run a join across the sample dataset
SELECT
  o.o_orderpriority,
  COUNT(*)            AS order_count,
  SUM(o.o_totalprice) AS total_value
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS o
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.CUSTOMER c
  ON o.o_custkey = c.c_custkey
GROUP BY o.o_orderpriority
ORDER BY total_value DESC;



SHOW GRANTS TO USER SNOWPATTI;
USE ROLE ACCOUNTADMIN;
SELECT CURRENT_USER(), CURRENT_ROLE();

--7.3  Compare warehouse sizes
ALTER WAREHOUSE lab_wh_patricia
SET WAREHOUSE_SIZE = 'SMALL';

ALTER WAREHOUSE lab_wh_patricia 
SET WAREHOUSE_SIZE = 'XSMALL';

--8.1 Create a stream on the orders table
CREATE OR REPLACE STREAM raw.orders_stream
ON TABLE raw.orders;
 
-- the stream starts empty relative to now
SELECT * FROM raw.orders_stream;

--8.2  Generate some change data
INSERT INTO raw.orders VALUES
  (2001, 'Meera Nair', 'Webcam', 'Electronics', 1, 2499.00, CURRENT_DATE(), 'West');
 
SELECT * FROM raw.orders_stream;   -- now shows the new row with METADATA$ACTION = 'INSERT'

--8.3  Create a target table and a task to consume the stream
CREATE OR REPLACE TABLE analytics.new_orders_log (
  order_id INT, customer_name STRING, product STRING,
  logged_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);
 
CREATE OR REPLACE TASK raw.process_new_orders
  WAREHOUSE = lab_wh_patricia
  SCHEDULE = '1 MINUTE'
WHEN
  SYSTEM$STREAM_HAS_DATA('raw.orders_stream')
AS
  INSERT INTO analytics.new_orders_log (order_id, customer_name, product)
  SELECT order_id, customer_name, product
  FROM raw.orders_stream
  WHERE METADATA$ACTION = 'INSERT';
 
ALTER TASK raw.process_new_orders RESUME;

--8.4  Verify
SELECT * FROM analytics.new_orders_log;
SELECT * FROM raw.orders_stream;  -- empty again
 
-- IMPORTANT: suspend the task when you're done so it doesn't run forever
ALTER TASK raw.process_new_orders SUSPEND;

