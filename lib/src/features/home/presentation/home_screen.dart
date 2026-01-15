import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:balloon_design_studio/src/core/entitlements/entitlements_config.dart';
import 'package:balloon_design_studio/src/core/entitlements/entitlements_provider.dart';
import 'package:balloon_design_studio/src/features/projects/presentation/projects_screen.dart';
import 'package:balloon_design_studio/src/features/templates/presentation/templates_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final entitlements = ref.watch(entitlementsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomeMessage,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                _buildEntitlementsCard(context, l10n, entitlements),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildFeatureCard(
                      context,
                      l10n.projects,
                      Icons.work_outline,
                      l10n.projectsDescription,
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProjectsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      l10n.templates,
                      Icons.dashboard_outlined,
                      l10n.templatesDescription,
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const TemplatesScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      l10n.pricing,
                      Icons.attach_money,
                      l10n.pricingDescription,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.pricing)),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      l10n.export,
                      Icons.download_outlined,
                      l10n.exportDescription,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.export)),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProjectsScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.newProject),
      ),
    );
  }
  
  Widget _buildEntitlementsCard(BuildContext context, AppLocalizations l10n, EntitlementsConfig config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.yourPlan(config.tier.name.toUpperCase()),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildLimitChip(
                  l10n.projectsLimit(config.maxProjects?.toString() ?? l10n.unlimited),
                ),
                _buildLimitChip(
                  l10n.elementsLimit(config.maxElementsPerProject?.toString() ?? l10n.unlimited),
                ),
                if (config.hasProfessionalPdf)
                  _buildLimitChip(l10n.professionalPdf),
                if (config.canExportImage)
                  _buildLimitChip(l10n.imageExport),
                if (config.aiOnlineEnabled)
                  _buildLimitChip(l10n.aiEnabled(config.aiRequestsPerDay)),
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
              Flexible(
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
