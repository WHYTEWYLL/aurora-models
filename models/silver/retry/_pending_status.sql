{{ config (
    materialized = "ephemeral"
) }}



 WITH pending_tx AS (

    SELECT
        DISTINCT(block_number),
        tx_hash
    FROM
        {{ ref('silver__transactions') }}
    WHERE
        _inserted_timestamp >= DATEADD(
            'day',
            -7,
            CURRENT_DATE
        )
        AND IS_PENDING = 'TRUE'

)

select 
    block_number,
    REPLACE(
        concat_ws('', '0x', to_char(block_number, 'XXXXXXXX')),
        ' ',
        ''
    ) AS block_number_hex,
    tx_hash
from  pending_tx