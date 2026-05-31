-- FIX-674 | GAP 1B -- Confirmation Loop Phase 2
-- Creates jaya_governance_reports table in Supabase
-- Run in Supabase SQL editor for the governance database
-- (utzkoozekztyztdxejij -- dedicated governance Supabase project)
-- Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
-- Date: 2026-05-30 | San Diego

CREATE TABLE IF NOT EXISTS jaya_governance_reports (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at          timestamptz DEFAULT now(),
    report_id           text NOT NULL,
    report_timestamp    text NOT NULL,
    period_start        text NOT NULL,
    period_end          text NOT NULL,
    events_total        integer NOT NULL,
    events_success      integer NOT NULL,
    events_failure      integer NOT NULL,
    requests_denied     integer NOT NULL,
    tasks_resolved      integer NOT NULL,
    tasks_escalated     integer NOT NULL,
    cri_min             integer NOT NULL,
    cri_max             integer NOT NULL,
    cri_current         integer NOT NULL,
    anomalies_detected  integer NOT NULL,
    proofs_generated    integer NOT NULL,
    chain_intact        boolean NOT NULL,
    report_hash         text NOT NULL
);

-- Append-only enforcement: no DELETE or UPDATE permitted
ALTER TABLE jaya_governance_reports ENABLE ROW LEVEL SECURITY;

CREATE POLICY "reports_insert_only" ON jaya_governance_reports
    FOR INSERT WITH CHECK (true);

CREATE POLICY "reports_read_public" ON jaya_governance_reports
    FOR SELECT USING (true);

-- Index for latest report queries
CREATE INDEX IF NOT EXISTS idx_reports_created_at
    ON jaya_governance_reports (created_at DESC);
-- FIX-677 correction: explicit grants required for Supabase REST API access
GRANT INSERT ON jaya_governance_reports TO anon, authenticated, service_role;
GRANT SELECT ON jaya_governance_reports TO anon, authenticated, service_role;
