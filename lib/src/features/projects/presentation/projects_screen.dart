import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:balloon_design_studio/src/features/projects/domain/project_model.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // Mock data for now - will be replaced with actual Isar database queries
    final projects = <Project>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myProjects),
      ),
      body: SafeArea(
        child: projects.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.work_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noProjects,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.createFirstProject,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return _buildProjectCard(context, l10n, project);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to create project screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.createProject)),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.newProject),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, AppLocalizations l10n, Project project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to project details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.edit}: ${project.name}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Chip(
                    label: Text(_getStatusText(l10n, project.status)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              if (project.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (project.clientName != null)
                    _buildInfoChip(
                      Icons.person_outline,
                      project.clientName!,
                    ),
                  if (project.eventType != null)
                    _buildInfoChip(
                      Icons.event,
                      project.eventType!,
                    ),
                  _buildInfoChip(
                    Icons.category_outlined,
                    l10n.elementsCount(project.elementCount),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _getStatusText(AppLocalizations l10n, ProjectStatus status) {
    switch (status) {
      case ProjectStatus.draft:
        return l10n.draft;
      case ProjectStatus.inProgress:
        return l10n.inProgress;
      case ProjectStatus.completed:
        return l10n.completed;
      case ProjectStatus.archived:
        return l10n.archived;
    }
  }
}
