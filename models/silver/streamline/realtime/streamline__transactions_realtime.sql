{{ config (
    materialized = "view",
    post_hook = if_data_call_function(
        func = "{{this.schema}}.udf_json_rpc(object_construct('sql_source', '{{this.identifier}}', 'external_table', 'transactions', 'exploded_key','[\"result\", \"transactions\"]', 'producer_batch_size',500, 'producer_limit_size', 5000000, 'worker_batch_size',50))",
        target = "{{this.schema}}.{{this.identifier}}"
    )
) }}

WITH last_3_days AS ({% if var('STREAMLINE_RUN_HISTORY') %}

    SELECT
        0 AS block_number
    {% else %}
    SELECT
        MAX(block_number) - 50000 AS block_number --aprox 3 days
    FROM
        {{ ref("streamline__blocks") }}
    {% endif %}),
    tbl AS (
        SELECT
            block_number,
            block_number_hex
        FROM
            {{ ref("streamline__blocks") }}
        WHERE
            (
                block_number >= (
                    SELECT
                        block_number
                    FROM
                        last_3_days
                )
            )
            AND block_number IS NOT NULL
        EXCEPT
        SELECT
            block_number,
            REPLACE(
                concat_ws('', '0x', to_char(block_number, 'XXXXXXXX')),
                ' ',
                ''
            ) AS block_number_hex
        FROM
            {{ ref("streamline__complete_transactions") }}
        WHERE
            (
                block_number >= (
                    SELECT
                        block_number
                    FROM
                        last_3_days
                )
            )
            AND block_number IS NOT NULL
    )
SELECT
    block_number,
    'eth_getBlockByNumber' AS method,
    CONCAT(
        block_number_hex,
        '_-_',
        'true'
    ) AS params
FROM
    {{ ref("streamline__blocks") }}
WHERE block_number <= 39511995