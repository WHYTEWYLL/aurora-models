{{ config(
    materialized = 'view',
    persist_docs ={ "relation": true,
    "columns": true },
    tags = ['core']
) }}

SELECT
    COALESCE (
        block_id,
        {{ dbt_utils.generate_surrogate_key(['block_number']) }}
    ) AS block_number,
    block_number,
    block_timestamp,
    'mainnet' AS network,
    'aurora' AS blockchain,
    tx_count,
    difficulty,
    total_difficulty,
    extra_data,
    gas_limit,
    gas_used,
    miner,
    nonce,
    parent_hash,
    HASH,
    receipts_root,
    sha3_uncles,
    SIZE,
    uncles AS uncle_blocks,
    OBJECT_CONSTRUCT(
        'difficulty',
        difficulty,
        'extraData',
        extra_data,
        'gasLimit',
        gas_limit,
        'gasUsed',
        gas_used,
        'hash',
        HASH,
        'logsBloom',
        logs_bloom,
        'miner',
        miner,
        'nonce',
        nonce,
        'number',
        NUMBER,
        'parentHash',
        parent_hash,
        'receiptsRoot',
        receipts_root,
        'sha3Uncles',
        sha3_uncles,
        'size',
        SIZE,
        'stateRoot',
        state_root,
        'timestamp',
        block_timestamp,
        'totalDifficulty',
        total_difficulty,
        'transactionsRoot',
        transactions_root,
        'uncles',
        uncles
    ) AS block_header_json,
    COALESCE (
        inserted_timestamp,
        _inserted_timestamp
    ) AS inserted_timestamp,
    COALESCE (
        modified_timestamp,
        _inserted_timestamp
    ) AS modified_timestamp
FROM
    {{ ref('silver__blocks') }}