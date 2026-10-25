with source_rows as (
    select
        example_events.event_id,
        {{ clean('example_events.event_name') }} as event_name,
        example_events.occurred_at::timestamp as occurred_at
    from {{ ref('example_events') }} as example_events
),

final as (
    select
        source_rows.event_id,
        source_rows.event_name,
        source_rows.occurred_at
    from source_rows
)

select * from final
