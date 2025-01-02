CREATE SEQUENCE IF NOT EXISTS note_seq;

CREATE TABLE IF NOT EXISTS note (
    id              BIGINT  NOT NULL,
	note_message    VARCHAR  NOT NULL,

	CONSTRAINT note_pk PRIMARY KEY (id)
);

ALTER TABLE note ALTER COLUMN id SET DEFAULT nextval('note_seq');
ALTER SEQUENCE note_seq OWNED BY note.id;