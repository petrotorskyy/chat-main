import 'package:flutter/material.dart';
import 'package:chat/data/message.dart';
import 'package:chat/data/message_dao.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../component/MessageWidget.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key? key}) : super(key: key);

  final messageDAO = MessageDAO();

  @override
  MessagePageState createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollDown();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _getListMessage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _textEditingController,
                      onSubmitted: (input) {
                        _sendMessage();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Write a message',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_checkTheMessage()) {
      final message = Message(
        _textEditingController.text,
        DateTime.now(),
      );
      widget.messageDAO.saveMessage(message);
      setState(() {
        _textEditingController.clear();
      });
    }
  }

  bool _checkTheMessage() => _textEditingController.text.isNotEmpty;

  Widget _getListMessage() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: widget.messageDAO.getMessages(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          return MessageWidget(message.createdAt, message.text);
        },
      ),
    );
  }

  void _scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
