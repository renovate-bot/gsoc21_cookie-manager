-- Renaming table
RENAME TABLE `#__ucm_history` TO `#__history`;
-- Rename ucm_item_id to item_id as the new primary identifier for the original content item
ALTER TABLE `#__history` CHANGE COLUMN `ucm_item_id` `item_id` VARCHAR(50) NOT NULL DEFAULT '' AFTER `version_id`;
-- Extend the original field content with the alias of the content type
UPDATE #__history AS h INNER JOIN #__content_types AS c ON h.ucm_type_id = c.type_id SET h.item_id = CONCAT(c.type_alias, '.', h.item_id);
-- Now we don't need the ucm_type_id anymore and drop it.
ALTER TABLE `#__history` DROP COLUMN `ucm_type_id`;
ALTER TABLE `#__history` ADD COLUMN `active_version` TINYINT(4) NOT NULL DEFAULT '0' AFTER `keep_forever`;
ALTER TABLE `#__history` ADD INDEX `idx_active_version` (`active_version`);
