-- Ejecutar en Supabase SQL Editor:
-- 1. Ir a https://supabase.com/dashboard → tu proyecto → SQL Editor
-- 2. Pegar y ejecutar este archivo completo

-- Tabla de preguntas falladas
CREATE TABLE IF NOT EXISTS wrong_questions (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    pregunta_id TEXT NOT NULL,
    question_data JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, pregunta_id)
);

-- Tabla de historial de tests
CREATE TABLE IF NOT EXISTS test_history (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    test_num INTEGER NOT NULL,
    score INTEGER NOT NULL,
    answers JSONB NOT NULL DEFAULT '[]',
    fecha TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_wrong_user ON wrong_questions(user_id);
CREATE INDEX IF NOT EXISTS idx_history_user ON test_history(user_id);
CREATE INDEX IF NOT EXISTS idx_history_test ON test_history(user_id, test_num);

-- RLS (Row Level Security)
ALTER TABLE wrong_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_history ENABLE ROW LEVEL SECURITY;

-- Políticas: cada usuario solo ve sus datos
CREATE POLICY "Users can read own wrong questions"
ON wrong_questions FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own wrong questions"
ON wrong_questions FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own wrong questions"
ON wrong_questions FOR DELETE
USING (auth.uid() = user_id);

CREATE POLICY "Users can read own history"
ON test_history FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own history"
ON test_history FOR INSERT
WITH CHECK (auth.uid() = user_id);
