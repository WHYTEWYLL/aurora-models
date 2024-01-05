{{ config(
    materialized = 'view',
    persist_docs ={ "relation": true,
    "columns": true }
) }}

SELECT
    block_number,
    block_timestamp,
    tx_hash,
    origin_function_signature,
    origin_from_address,
    origin_to_address,
    event_index,
    contract_address,
    topics,
    DATA,
    event_removed,
    tx_status,
    _log_id,
    COALESCE (
        logs_id,
        {{ dbt_utils.generate_surrogate_key(['BLOCK_NUMBER','tx_hash', '_LOG_ID']) }}
    ) AS fact_logs_id,
    COALESCE (
        inserted_timestamp,
        _inserted_timestamp
    ) AS inserted_timestamp,
    COALESCE (
        modified_timestamp,
        _inserted_timestamp
    ) AS modified_timestamp
FROM
    {{ ref('silver__logs') }}
