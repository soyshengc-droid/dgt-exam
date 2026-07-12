    -- Ejecutar en Supabase SQL Editor para actualizar el esquema
-- (Elimina las tablas viejas y crea las nuevas sin dependencia de auth.users)

DROP TABLE IF EXISTS wrong_questions CASCADE;
DROP TABLE IF EXISTS test_history CASCADE;

CREATE TABLE wrong_questions (
    id BIGSERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    pregunta_id TEXT NOT NULL,
    question_data JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(username, pregunta_id)
);

CREATE TABLE test_history (
    id BIGSERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    test_num INTEGER NOT NULL,
    score INTEGER NOT NULL,
    answers JSONB NOT NULL DEFAULT '[]',
    fecha TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_wrong_user ON wrong_questions(username);
CREATE INDEX idx_history_user ON test_history(username);

ALTER TABLE wrong_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_history ENABLE ROW LEVEL SECURITY;

-- Permitir acceso público con anon key
CREATE POLICY "Allow all on wrong_questions" ON wrong_questions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on test_history" ON test_history FOR ALL USING (true) WITH CHECK (true);
