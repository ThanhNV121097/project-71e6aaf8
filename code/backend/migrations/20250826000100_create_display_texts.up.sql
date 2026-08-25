CREATE TABLE IF NOT EXISTS schema_migrations (
    version text PRIMARY KEY,
    applied_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE display_texts (
    id smallint PRIMARY KEY,
    body text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT display_texts_singleton CHECK (id = 1),
    CONSTRAINT display_texts_body_not_blank CHECK (length(trim(body)) > 0),
    CONSTRAINT display_texts_body_max CHECK (length(body) <= 500)
);

INSERT INTO display_texts (id, body)
VALUES (1, 'Hello Word')
ON CONFLICT (id) DO NOTHING;
