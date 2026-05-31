-- FIX-692 | jaya_agents table
-- Tracks registered agents from Jaya Runtime
-- Written by Jaya on register/deregister/status change

CREATE TABLE IF NOT EXISTS jaya_agents (
  id                bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  agent_id          text NOT NULL,
  label             text NOT NULL,
  tier              text NOT NULL,
  status            text NOT NULL,
  permissions       text NOT NULL,
  expected_actions  text NOT NULL,
  autonomy_class    text NOT NULL DEFAULT 'ClassA',
  registered_at     text NOT NULL,
  updated_at        text NOT NULL,
  event_type        text NOT NULL
);

GRANT INSERT, SELECT, UPDATE ON jaya_agents TO anon, authenticated, service_role;
GRANT USAGE, SELECT ON SEQUENCE jaya_agents_id_seq TO anon, authenticated, service_role;