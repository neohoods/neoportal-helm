-- Migration V3.5: Add Matrix conversation timeout configuration support

-- Assistant Debug Conversations Tables
-- Main table for storing debug conversations
-- Conversation ID format: "portal-{uuid}" for Portal conversations, "matrix-{roomId}" for Matrix conversations
CREATE TABLE assistant_debug_conversations (
    conversation_id VARCHAR(255) PRIMARY KEY,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_message_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    conversation_data JSONB NOT NULL,
    -- Cost metrics (calculated from LLM requests)
    total_cost DOUBLE PRECISION,
    -- LLM Judge evaluation metrics (aggregated from LLM_JUDGE events)
    judge_score DOUBLE PRECISION,
    judge_correctness DOUBLE PRECISION,
    judge_clarity DOUBLE PRECISION,
    judge_completeness DOUBLE PRECISION,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Authors table (many-to-many relationship between conversations and users)
CREATE TABLE assistant_debug_conversation_authors (
    conversation_id VARCHAR(255) NOT NULL REFERENCES assistant_debug_conversations(conversation_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (conversation_id, user_id)
);

-- Indexes for assistant_debug_conversations
CREATE INDEX idx_assistant_debug_conversations_last_message_date 
    ON assistant_debug_conversations(last_message_date);

CREATE INDEX idx_assistant_debug_conversation_authors_user_id 
    ON assistant_debug_conversation_authors(user_id);

-- Indexes for filtering by cost and judge scores
CREATE INDEX idx_assistant_debug_conversations_total_cost 
    ON assistant_debug_conversations(total_cost) WHERE total_cost IS NOT NULL;

CREATE INDEX idx_assistant_debug_conversations_judge_score 
    ON assistant_debug_conversations(judge_score) WHERE judge_score IS NOT NULL;

CREATE INDEX idx_assistant_debug_conversations_judge_correctness 
    ON assistant_debug_conversations(judge_correctness) WHERE judge_correctness IS NOT NULL;

CREATE INDEX idx_assistant_debug_conversations_judge_clarity 
    ON assistant_debug_conversations(judge_clarity) WHERE judge_clarity IS NOT NULL;

CREATE INDEX idx_assistant_debug_conversations_judge_completeness 
    ON assistant_debug_conversations(judge_completeness) WHERE judge_completeness IS NOT NULL;

-- GIN index for JSONB queries (allows efficient queries on conversation_data)
CREATE INDEX idx_assistant_debug_conversations_conversation_data 
    ON assistant_debug_conversations USING GIN (conversation_data);

-- Index on start_date for cleanup queries
CREATE INDEX idx_assistant_debug_conversations_start_date 
    ON assistant_debug_conversations(start_date);

-- Create trigger for assistant_debug_conversations updated_at
CREATE TRIGGER update_assistant_debug_conversations_updated_at BEFORE UPDATE ON assistant_debug_conversations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();