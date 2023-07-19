{{ config (
    materialized = 'view',
    tags = ['full_test']
) }}

SELECT
    CONCAT(BLOCK_NUMBER, TX_HASH, POSITION) AS UNIQUE_ID,
    *
FROM
    {{ ref('silver__transactions') }}
