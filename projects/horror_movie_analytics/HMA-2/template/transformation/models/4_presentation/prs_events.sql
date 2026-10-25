with domain_events as (
    select
        dmn_events.event_id,
        dmn_events.event_name,
        dmn_events.occurred_at,
        dmn_events.is_deleted
    from {{ ref('dmn_events') }} as dmn_events
),

final as (
    select
        domain_events.event_id,
        domain_events.event_name,
        domain_events.occurred_at,
        domain_events.is_deleted
    from domain_events
)

select * from final
