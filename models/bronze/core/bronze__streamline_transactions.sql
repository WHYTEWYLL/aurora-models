{{ config (
    materialized = 'view'
) }}

WITH meta AS (

    SELECT
        job_created_time AS _inserted_timestamp,
        file_name,
        CAST(SPLIT_PART(SPLIT_PART(file_name, '/', 4), '_', 1) AS INTEGER) AS _partition_by_block_id
    FROM
        TABLE(
            information_schema.external_table_file_registration_history(
                start_time => GREATEST(DATEADD('day', -1, CURRENT_TIMESTAMP), '2023-08-01 18:44:00.000' :: timestamp_ntz),
                table_name => '{{ source( "bronze_streamline", "transactions") }}'
            )
        ) A
)
SELECT
    block_number,
    DATA :hash ::STRING AS tx_hash,
    _inserted_timestamp,
    MD5(
        CAST(
            COALESCE(CAST(CONCAT(block_number, '_-_', COALESCE(DATA :hash ::STRING, '')) AS text), '' :: STRING) AS text
        )
    ) AS id,
    s._partition_by_block_id,
    s.value AS VALUE
FROM
    {{ source(
        "bronze_streamline",
        "transactions"
    ) }}
    s
    JOIN meta b
    ON b.file_name = metadata$filename
    AND b._partition_by_block_id = s._partition_by_block_id
WHERE
    b._partition_by_block_id = s._partition_by_block_id
    AND (
        DATA :error :code IS NULL
        OR DATA :error :code NOT IN (
            '-32000',
            '-32001',
            '-32002',
            '-32003',
            '-32004',
            '-32005',
            '-32006',
            '-32007',
            '-32008',
            '-32009',
            '-32010'
        )
    )
