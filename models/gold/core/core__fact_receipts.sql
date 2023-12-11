{{ config(
    materialized = 'view',
    persist_docs ={ "relation": true,
    "columns": true },
    tags = ['core']
) }}

SELECT
    receipts_id,
    block_number,
    block_timestamp,
    block_hash,
    cumulative_gas_used,
    from_address,
    to_address,
    gas_used,
    logs,
    logs_bloom,
    status,
    tx_success,
    tx_status,
    tx_hash,
    POSITION,
    TYPE,
    near_receipt_hash,
    near_transaction_hash,
    inserted_timestamp,
    modified_timestamp,
    invocation_id
FROM
    {{ ref('silver__receipts') }}