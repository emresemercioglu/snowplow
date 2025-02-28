local common_measures = import 'common_measures.jsonnet';

local all_event_props = if std.extVar('custom_event_schema') != null then std.extVar('custom_event_schema') else [];
local unique_events = std.uniq(std.sort(std.map(function(attr) attr.EVENT_NAME, all_event_props)));

std.map(function(event_type)
  local current_event_props = std.filter(function(p) p.EVENT_NAME == event_type, all_event_props);
  local event_db_name = current_event_props[0].EVENT_DB;

  {
    name: 'snowplow_event_' + event_db_name,
    target: std.extVar('events'),
    label: event_type,
    mappings: {
      eventTimestamp: 'dvce_sent_tstamp',
      userId: 'user_id',
    },
    category: 'Snowplow Events',
    measures: common_measures,
    dimensions: common_dimensions,
  }, unique_events)
