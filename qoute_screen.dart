import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final List<Map<String, String>> quotes = [
    {"quote": "The best way to predict the future is to create it.", "author": "Peter Drucker"},
    {"quote": "Success is not final; failure is not fatal. It is the courage to continue that counts.", "author": "Winston Churchill"},
    {"quote": "Happiness is not something ready-made. It comes from your own actions.", "author": "Dalai Lama"},
    {"quote": "Believe you can and you're halfway there.", "author": "Theodore Roosevelt"},
    {"quote": "The only limit to our realization of tomorrow is our doubts of today.", "author": "Franklin D. Roosevelt"},
    
  ];

  Map<String, String> currentQuote = {
    "quote": "Click the button below to generate a quote!",
    "author": "",
  };

  void generateQuote() {
    setState(() {
      currentQuote = (quotes..shuffle()).first;
    });
  }

  void addNewQuote(String quote, String author) {
    setState(() {
      quotes.add({"quote": quote, "author": author});
      currentQuote = {"quote": quote, "author": author};
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quote added successfully!")),
    );
  }

  void deleteQuote(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Quote"),
        content: const Text("Are you sure you want to delete this quote?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                quotes.removeAt(index);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Quote deleted successfully!")),
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void showAddQuoteDialog() {
    String newQuote = "";
    String newAuthor = "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Quote"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => newQuote = value,
              decoration: const InputDecoration(
                labelText: "Quote",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) => newAuthor = value,
              decoration: const InputDecoration(
                labelText: "Author",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (newQuote.isNotEmpty && newAuthor.isNotEmpty) {
                addNewQuote(newQuote, newAuthor);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill out both fields.")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Quote Generator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    currentQuote['quote']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.teal,
                    ),
                  ),
                  if (currentQuote['author']!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "- ${currentQuote['author']}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateQuote,
              child: const Text("Generate Quote"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Share.share("${currentQuote['quote']}\n\n- ${currentQuote['author']}");
              },
              child: const Text("Share Quote"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  final quote = quotes[index];
                  return Card(
                    child: ListTile(
                      title: Text(quote['quote']!),
                      subtitle: Text("- ${quote['author']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () => deleteQuote(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddQuoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
