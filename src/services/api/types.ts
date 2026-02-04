export type ParticipantRole = "owner" | "admin" | "member";

export interface Participant {
  id: string;
  role: ParticipantRole;
  joinedAt: string;
  lastActive?: string;
}

// TODO: Replace with the actual message payload shared across the web client
// once those types are colocated in this repo.
export type MessageResponse = Record<string, unknown>;

export interface ChatSummary {
  id: string;
  type: "group" | "private" | "bot";
  name: string;
  avatar?: string;
  participants: Participant[];
  lastMessage?: MessageResponse;
  unreadCount: number;
  isTyping: boolean;
  typingUser?: string;
  isBot: boolean;
  isPinned: boolean;
}

export interface ChatDetail extends Omit<ChatSummary, "lastMessage" | "typingUser" | "isPinned"> {
  participants: Participant[];
}