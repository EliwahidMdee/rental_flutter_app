import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/empty_state.dart';
import '../../../core/utils/formatters.dart';

/// Conversations Screen
/// 
/// List of all conversations for the current user

class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});

  @override
  ConsumerState<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  // Mock data - replace with real data from provider
  final List<Conversation> _conversations = [
    Conversation(
      id: 1,
      participantName: 'John Landlord',
      participantRole: 'Landlord',
      propertyName: 'Sunset Apartments #101',
      lastMessage: 'I\'ll send you a video guide. The thermostat is located in the hallway.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 5)),
      unreadCount: 2,
      avatarUrl: null,
    ),
    Conversation(
      id: 2,
      participantName: 'Sarah Admin',
      participantRole: 'Admin',
      propertyName: 'System Messages',
      lastMessage: 'Your payment has been approved.',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      avatarUrl: null,
    ),
    Conversation(
      id: 3,
      participantName: 'Mike Tenant',
      participantRole: 'Tenant',
      propertyName: 'Downtown Loft #305',
      lastMessage: 'Thank you for fixing the leak!',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
      unreadCount: 0,
      avatarUrl: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: _conversations.isEmpty
          ? const EmptyState(
              message: 'No conversations yet',
              subtitle: 'Start a conversation with your landlord or tenants',
              icon: Icons.message_outlined,
            )
          : RefreshIndicator(
              onRefresh: () async {
                // TODO: Refresh conversations
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  final conversation = _conversations[index];
                  return _buildConversationTile(context, conversation);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewMessageDialog(context);
        },
        child: const Icon(Icons.message),
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, Conversation conversation) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: _getRoleColor(conversation.participantRole).withOpacity(0.2),
            child: Text(
              conversation.participantName[0],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getRoleColor(conversation.participantRole),
              ),
            ),
          ),
          if (conversation.unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Center(
                  child: Text(
                    '${conversation.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation.participantName,
              style: TextStyle(
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          Text(
            Formatters.relativeTime(conversation.lastMessageTime),
            style: TextStyle(
              fontSize: 12,
              color: conversation.unreadCount > 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conversation.propertyName,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            conversation.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: conversation.unreadCount > 0
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
      onTap: () {
        // Navigate to conversation detail
        context.push('/messages/${conversation.id}');
      },
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.blue;
      case 'landlord':
        return Colors.green;
      case 'tenant':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showNewMessageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select who you want to message:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Landlord'),
              subtitle: const Text('Contact your property landlord'),
              onTap: () {
                Navigator.pop(context);
                context.push('/messages/new?to=landlord');
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('Support'),
              subtitle: const Text('Contact support team'),
              onTap: () {
                Navigator.pop(context);
                context.push('/messages/new?to=support');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// Conversation Model
class Conversation {
  final int id;
  final String participantName;
  final String participantRole;
  final String propertyName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String? avatarUrl;

  Conversation({
    required this.id,
    required this.participantName,
    required this.participantRole,
    required this.propertyName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.avatarUrl,
  });
}
