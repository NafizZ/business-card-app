
import 'package:business_card_app/widgets/reusable_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/business_provider.dart';

class BusinessListScreen extends StatelessWidget {
  const BusinessListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Finder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name or location',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                context.read<BusinessProvider>().search(query);
              },
            ),
          ),
          Expanded(
            child: Consumer<BusinessProvider>(
              builder: (context, provider, child) {
                switch (provider.state) {
                  case AppState.loading:
                    return const Center(child: CircularProgressIndicator());
                  case AppState.error:
                    return _buildErrorState(context, provider.errorMessage);
                  case AppState.success:
                    if (provider.filteredBusinesses.isEmpty) {
                      return _buildEmptyState(provider.searchQuery);
                    }
                    return _buildSuccessState(provider);
                  default:
                    return const Center(child: Text('Welcome!'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            Text(
              'An error occurred',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () {
                context.read<BusinessProvider>().fetchBusinesses();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String searchQuery) {
    return Center(
      child: Text(
        searchQuery.isEmpty
            ? 'No businesses found.'
            : 'No results for "$searchQuery"',
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildSuccessState(BusinessProvider provider) {
    return ListView.builder(
      itemCount: provider.filteredBusinesses.length,
      itemBuilder: (context, index) {
        final business = provider.filteredBusinesses[index];
        return ReusableCard(
          viewModel: business,
          onTap: () {
            context.go('/details', extra: business);
          },
        );
      },
    );
  }
}

