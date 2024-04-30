{{ config(
    materialized = 'view',
    persist_docs ={ "relation": true,
    "columns": true },
    tags = ['core']
) }}

SELECT
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
    COALESCE (
        receipts_id,
        {{ dbt_utils.generate_surrogate_key(['BLOCK_NUMBER', 'TX_HASH']) }}
    ) AS fact_receipts_id,
    COALESCE (
        inserted_timestamp,
        _inserted_timestamp
    ) AS inserted_timestamp,
    COALESCE (
        modified_timestamp,
        _inserted_timestamp
    ) AS modified_timestamp
FROM
    {{ ref('silver__receipts') }}
