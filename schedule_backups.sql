/* https://www.cockroachlabs.com/docs/stable/create-schedule-for-backup */
CREATE SCHEDULE defaultdb_schedule
FOR BACKUP DATABASE defaultdb
INTO 'gs://YOUR_CLOUD_STORAGE_BUCKET/OPTIONAL_FOLDER?AUTH=specified&CREDENTIALS=[REDACTED...]'
WITH revision_history
RECURRING '@hourly'
WITH SCHEDULE OPTIONS first_run = 'now';

