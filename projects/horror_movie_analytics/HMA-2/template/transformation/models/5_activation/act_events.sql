with presentation_events as (
    select
        prs_events.event_id,
        prs_events.event_name,
        prs_events.occurred_at,
        prs_events.is_deleted
    from {{ ref('prs_events') }} as prs_events
),

final as (
    select
        presentation_events.event_id,
        presentation_events.event_name,
        presentation_events.occurred_at,
        presentation_events.is_deleted
    from presentation_events
    where presentation_events.is_deleted = false
)

select * from final
