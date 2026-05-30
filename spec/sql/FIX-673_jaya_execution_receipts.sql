-- FIX-673 | GAP 1A -- Confirmation Loop Phase 1
-- Creates jaya_execution_receipts table in Supabase
-- Run in Supabase SQL editor for the governance database
-- (utzkoozekztyztdxejij -- dedicated governance Supabase project)
-- Builder: Jose Ramon Alvarado McHerron AKA Jose Ramon Bautista Jr.
-- Date: 2026-05-30 | San Diego

CREATE TABLE IF NOT EXISTS jaya_execution_receipts (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at          timestamptz DEFAULT now(),
    receipt_id          text NOT NULL,
    action_type         text NOT NULL,
    execution_status    text NOT NULL,
    confirmation_level  text NOT NULL,
    ledger_entry_ref    text,
    event_hash_ref      text,
    receipt_timestamp   text NOT NULL,
    receipt_hash        text NOT NULL,
    prev_receipt_hash   text,
    jaya_version        text NOT NULL
);

-- Append-only enforcement: no DELETE or UPDATE permitted
ALTER TABLE jaya_execution_receipts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "receipts_insert_only" ON jaya_execution_receipts
    FOR INSERT WITH CHECK (true);

CREATE POLICY "receipts_read_public" ON jaya_execution_receipts
    FOR SELECT USING (true);

-- Index for chain queries (latest receipt lookup)
CREATE INDEX IF NOT EXISTS idx_receipts_created_at
    ON jaya_execution_receipts (created_at DESC);

-- Index for confirmation level filtering
CREATE INDEX IF NOT EXISTS idx_receipts_confirmation_level
    ON jaya_execution_receipts (confirmation_level);