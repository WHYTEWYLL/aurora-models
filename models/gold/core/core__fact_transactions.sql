{{ config(
    materialized = 'view',
    persist_docs ={ "relation": true,
    "columns": true }
) }}

SELECT
    block_number,
    block_hash,
    block_timestamp,
    tx_hash,
    nonce,
    POSITION,
    origin_function_signature,
    from_address,
    to_address,
    VALUE,
    tx_fee,
    gas_price,
    gas AS gas_limit,
    gas_used,
    cumulative_Gas_Used,
    input_data,
    tx_status AS status,
    max_fee_per_gas,
    max_priority_fee_per_gas,
    r,
    s,
    v,
    tx_type,
    COALESCE (
        tx_id,
        {{ dbt_utils.generate_surrogate_key(['BLOCK_NUMBER', 'TX_HASH', 'POSITION']) }}
    ) AS fact_transactions_id,
    COALESCE (
        inserted_timestamp,
        _inserted_timestamp
    ) AS inserted_timestamp,
    COALESCE (
        modified_timestamp,
        _inserted_timestamp
    ) AS modified_timestamp
FROM
    {{ ref('silver__transactions') }}
