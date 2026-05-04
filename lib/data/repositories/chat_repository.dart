import '../mock/mock_data.dart';
import '../models/chat_preview.dart';
import '../models/conversation_message.dart';

class ChatRepository {
  const ChatRepository();

  List<ChatPreview> getChats() => MockData.chats;

  List<ConversationMessage> getConversation(String studentId) => MockData.conversation;
}
