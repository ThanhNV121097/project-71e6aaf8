CREATE TABLE IF NOT EXISTS schema_migrations (
  filename text PRIMARY KEY,
  applied_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS greetings (
  id integer PRIMARY KEY,
  message text NOT NULL CHECK (length(message) > 0),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT greetings_singleton CHECK (id = 1)
);

INSERT INTO greetings (id, message)
VALUES (1, 'Hello Word')
ON CONFLICT (id) DO NOTHING;
