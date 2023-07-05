{{ config (
    materialized = 'view'
) }}

{% set partition_function = "CAST(SPLIT_PART(SPLIT_PART(file_name, '/', 4), '_', 1) AS INTEGER )" %}
{% set partition_name = "_partition_by_block_id" %}
{% set unique_key = "block_number" %}


WITH meta AS (
        SELECT
            registered_on AS _inserted_timestamp,
            file_name,
            {{ partition_function }} AS {{ partition_name }}
        FROM
            TABLE(
                information_schema.external_table_files(
                    table_name => '{{ source( "streamline", "tx_receipts") }}'
                )
            ) A
)

SELECT
    {{ unique_key }},
    DATA:result as DATA,
    _inserted_timestamp,
    MD5(
        CAST(
            COALESCE(CAST({{ unique_key }} AS text), '' :: STRING) AS text
        )
    ) AS id,
    s.{{ partition_name }},
    s.value AS VALUE
FROM
    {{ source(
        "streamline",
        "tx_receipts"
    ) }}
    s
    JOIN meta b
    ON b.file_name = metadata$filename
    AND b.{{ partition_name }} = s.{{ partition_name }}
WHERE
    b.{{ partition_name }} = s.{{ partition_name }}
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
