import 'package:flutter/material.dart';
import '../services/api_service.dart';

class QuoteWidget extends StatefulWidget {
  const QuoteWidget({Key? key}) : super(key: key);

  @override
  _QuoteWidgetState createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  final ApiService _apiService = ApiService();
  Quote? _quote;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  Future<void> _fetchQuote() async {
    if (mounted && _quote != null) {
      setState(() => _isLoading = true);
    }
    final quote = await _apiService.fetchRandomQuote();
    if (mounted) {
      setState(() {
        if (quote != null) _quote = quote;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _quote == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_quote == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '"${_quote!.content}"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '- ${_quote!.author}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey[400]),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.sync, size: 18, color: Colors.grey[400]),
                    onPressed: _fetchQuote,
                    splashRadius: 20,
                    tooltip: 'New Quote',
                  ),
          ),
        ],
      ),
    );
  }
}
