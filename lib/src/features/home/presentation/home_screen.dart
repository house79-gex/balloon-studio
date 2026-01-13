import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balloon_design_studio/src/core/entitlements/entitlements_config.dart';
import 'package:balloon_design_studio/src/core/entitlements/entitlements_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlements = ref.watch(entitlementsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balloon Design Studio'),
        actions: [
          Chip(
            label: Text(
              entitlements.tier.name.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: entitlements.tier == EntitlementTier.pro
                ? Colors.amber
                : Colors.grey,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Balloon Design Studio',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            _buildEntitlementsCard(context, entitlements),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    'Projects',
                    Icons.work_outline,
                    'Manage your balloon designs',
                    () {},
                  ),
                  _buildFeatureCard(
                    context,
                    'Templates',
                    Icons.dashboard_outlined,
                    'Browse design templates',
                    () {},
                  ),
                  _buildFeatureCard(
                    context,
                    'Pricing',
                    Icons.attach_money,
                    'Configure pricing',
                    () {},
                  ),
                  _buildFeatureCard(
                    context,
                    'Export',
                    Icons.download_outlined,
                    'Export designs and quotes',
                    () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('New Project'),
      ),
    );
  }
  
  Widget _buildEntitlementsCard(BuildContext context, EntitlementsConfig config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Plan: ${config.tier.name.toUpperCase()}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildLimitChip(
                  'Projects: ${config.maxProjects?.toString() ?? "Unlimited"}',
                ),
                _buildLimitChip(
                  'Elements: ${config.maxElementsPerProject?.toString() ?? "Unlimited"}',
                ),
                if (config.hasProfessionalPdf)
                  _buildLimitChip('Professional PDF'),
                if (config.canExportImage)
                  _buildLimitChip('Image Export'),
                if (config.aiOnlineEnabled)
                  _buildLimitChip('AI Enabled (${config.aiRequestsPerDay}/day)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLimitChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
  
  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
