{{ config (
    materialized = "view",
    post_hook = if_data_call_function(
        func = "{{this.schema}}.udf_json_rpc(object_construct('sql_source', '{{this.identifier}}', 'external_table', 'traces', 'exploded_key','[\"result\"]', 'producer_batch_size',10000, 'producer_limit_size',2000000, 'worker_batch_size',100))",
        target = "{{this.schema}}.{{this.identifier}}"
    )
) }}

WITH tbl AS (

    SELECT
        block_number,
        tx_hash
    FROM
        {{ ref("silver__transactions") }}
    WHERE
        block_number IS NOT NULL
        AND tx_hash IS NOT NULL
    EXCEPT
    SELECT
        block_number,
        tx_hash
    FROM
        {{ ref("streamline__complete_traces") }}
    WHERE
        block_number IS NOT NULL
        AND tx_hash IS NOT NULL
)
SELECT
    block_number,
    'debug_traceTransaction' AS method,
    tx_hash AS params
FROM
    tbl
ORDER BY
    block_number ASC
LIMIT
    50
