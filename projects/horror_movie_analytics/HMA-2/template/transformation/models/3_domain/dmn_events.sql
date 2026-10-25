with intermediate_events as (
    select
        int_example_events.event_id,
        int_example_events.event_name,
        int_example_events.occurred_at,
        int_example_events.is_deleted
    from {{ ref('int_example_events') }} as int_example_events
),

final as (
    select
        intermediate_events.event_id,
        intermediate_events.event_name,
        intermediate_events.occurred_at,
        intermediate_events.is_deleted
    from intermediate_events
)

select * from final
