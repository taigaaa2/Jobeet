-- Convert schema 'Jobeet-Schema-3-SQLite.sql' to 'Jobeet-Schema-4-SQLite.sql':;

BEGIN;

ALTER TABLE jobeet_job ADD COLUMN company VARCHAR(255);

ALTER TABLE jobeet_job ADD COLUMN logo VARCHAR(255);

ALTER TABLE jobeet_job ADD COLUMN url VARCHAR(255);


COMMIT;

