-- Ensure historical group creators are marked as owners
UPDATE chat_participants AS cp
SET role = 'owner'
FROM chats c
WHERE cp.chat_id = c.id
  AND c.created_by = cp.user_id
  AND c.type = 'group'
  AND cp.role <> 'owner';
