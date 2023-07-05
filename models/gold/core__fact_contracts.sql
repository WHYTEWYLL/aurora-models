{{ config(
    materialized = 'view',
    persist_docs ={ "relation": true,
    "columns": true },
    tags = ['core']
) }}

SELECT
*
FROM
    {{ ref('silver__relevant_contracts') }}
