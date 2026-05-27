-- Keep historical V1 immutable: widen TV display duration via forward migration.
-- Previous limit was <= 15 seconds; new expected limit is <= 600 seconds.

ALTER TABLE tv_info
DROP CONSTRAINT IF EXISTS tv_info_display_duration_seconds_check;

ALTER TABLE tv_info
ADD CONSTRAINT tv_info_display_duration_seconds_check
CHECK (display_duration_seconds >= 3 AND display_duration_seconds <= 600);
