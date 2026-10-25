with staging_events as (
    select
        stg_example_events.event_id,
        stg_example_events.event_name,
        stg_example_events.occurred_at
    from {{ ref('stg_example_events') }} as stg_example_events
),

final as (
    select
        staging_events.event_id,
        staging_events.event_name,
        staging_events.occurred_at,
        staging_events.event_name = 'deleted' as is_deleted
    from staging_events
)

select * from final
