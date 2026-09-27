-- Endurance migration for existing BrProject databases.
-- Run this ONCE before starting the server with the Endurance mod.
--
-- This must not use DEFAULT 0: 0 means a genuinely broken item.
-- Existing rows receive -1 and are initialized to MAX_ENDURANCE by ItemInstance
-- when they are restored by the server.

ALTER TABLE items
    ADD COLUMN endurance INT NOT NULL DEFAULT -1;
