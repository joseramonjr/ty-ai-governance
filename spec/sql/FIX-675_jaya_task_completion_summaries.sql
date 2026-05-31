-- FIX-675 | GAP 1C -- Confirmation Loop Phase 3
-- Creates jaya_task_completion_summaries table in Supabase
-- Run in Supabase SQL editor for the governance database
-- (utzkoozekztyztdxejij -- dedicated governance Supabase project)
-- Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
-- Date: 2026-05-30 | San Diego
-- Spec: TY_GOVERNANCE_CONFIRMATION_LOOP_SPEC_v0.1.md Section 5.2

CREATE TABLE IF NOT EXISTS jaya_task_completion_summaries (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at      timestamptz DEFAULT now(),
    task_id         text NOT NULL,
    task_type       text NOT NULL,
    outcome         text NOT NULL,
    receipt_count   integer NOT NULL,
    period_start    text NOT NULL,
    period_end      text NOT NULL,
    summary_text    text NOT NULL,
    final_cri       integer NOT NULL,
    chain_intact    boolean NOT NULL,
    summary_hash    text NOT NULL
);

-- Append-only enforcement: no DELETE or UPDATE permitted
ALTER TABLE jaya_task_completion_summaries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "summaries_insert_only" ON jaya_task_completion_summaries
    FOR INSERT WITH CHECK (true);

CREATE POLICY "summaries_read_public" ON jaya_task_completion_summaries
    FOR SELECT USING (true);

-- Index for latest summary queries
CREATE INDEX IF NOT EXISTS idx_summaries_created_at
    ON jaya_task_completion_summaries (created_at DESC);

-- Index for outcome filtering (RESOLVED_INTERNAL vs ESCALATED_TO_GUARDIAN)
CREATE INDEX IF NOT EXISTS idx_summaries_outcome
    ON jaya_task_completion_summaries (outcome);
-- FIX-677 correction: explicit grants required for Supabase REST API access
GRANT INSERT ON jaya_task_completion_summaries TO anon, authenticated, service_role;
GRANT SELECT ON jaya_task_completion_summaries TO anon, authenticated, service_role;
