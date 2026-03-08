import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/star_rating.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/tutor_model.dart';

/// Pantalla de búsqueda de tutores (RF-05, RF-06).
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  String? _selectedModalidad;
  RangeValues _priceRange = const RangeValues(10000, 100000);
  double _minRating = 0;

  List<TutorModel> get _filteredTutors {
    return MockData.tutores.where((t) {
      if (!t.aprobadoPorAdmin) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesMaterias =
            t.materias.any((m) => m.toLowerCase().contains(q));
        final matchesNombre = t.nombre.toLowerCase().contains(q);
        if (!matchesMaterias && !matchesNombre) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _filteredTutors;

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Tutores')),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Buscar por materia o nombre...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () => _showFilters(context),
                ),
              ),
            ),
          ),

          // Chips de filtros activos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(
                    label: 'Online',
                    isSelected: _selectedModalidad == AppConstants.modalidadOnline,
                    onTap: () => setState(() {
                      _selectedModalidad =
                          _selectedModalidad == AppConstants.modalidadOnline
                              ? null
                              : AppConstants.modalidadOnline;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Presencial',
                    isSelected:
                        _selectedModalidad == AppConstants.modalidadPresencial,
                    onTap: () => setState(() {
                      _selectedModalidad =
                          _selectedModalidad == AppConstants.modalidadPresencial
                              ? null
                              : AppConstants.modalidadPresencial;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: '⭐ 4+',
                    isSelected: _minRating >= 4,
                    onTap: () => setState(() {
                      _minRating = _minRating >= 4 ? 0 : 4;
                    }),
                  ),
                ],
              ),
            ),
          ),

          // Contador de resultados
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${resultados.length} tutores encontrados',
                  style: AppTextStyles.body2,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sort, size: 18),
                  label: const Text('Ordenar'),
                ),
              ],
            ),
          ),

          // Lista de resultados
          Expanded(
            child: resultados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 64, color: AppColors.textHint),
                        const SizedBox(height: 16),
                        Text('No se encontraron tutores',
                            style: AppTextStyles.heading3),
                        const SizedBox(height: 4),
                        Text('Intenta con otra búsqueda',
                            style: AppTextStyles.body2),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: resultados.length,
                    itemBuilder: (context, index) {
                      return _TutorSearchCard(
                        tutor: resultados[index],
                        onTap: () {
                          // TODO: Navegar al perfil del tutor
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Filtros Avanzados', style: AppTextStyles.heading3),
                  const SizedBox(height: 24),

                  // Rango de precios
                  Text('Rango de precios por hora',
                      style: AppTextStyles.subtitle1),
                  RangeSlider(
                    values: _priceRange,
                    min: 10000,
                    max: 100000,
                    divisions: 18,
                    labels: RangeLabels(
                      '\$${_priceRange.start.toStringAsFixed(0)}',
                      '\$${_priceRange.end.toStringAsFixed(0)}',
                    ),
                    onChanged: (v) {
                      setModalState(() => _priceRange = v);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Calificación mínima
                  Text('Calificación mínima',
                      style: AppTextStyles.subtitle1),
                  const SizedBox(height: 8),
                  StarRating(
                    rating: _minRating,
                    size: 32,
                    allowEdit: true,
                    onRatingChanged: (v) {
                      setModalState(() => _minRating = v);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botón aplicar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: const Text('Aplicar Filtros'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        setModalState(() {
                          _priceRange = const RangeValues(10000, 100000);
                          _minRating = 0;
                          _selectedModalidad = null;
                        });
                        setState(() {});
                      },
                      child: const Text('Limpiar Filtros'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TutorSearchCard extends StatelessWidget {
  final TutorModel tutor;
  final VoidCallback onTap;

  const _TutorSearchCard({required this.tutor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAvatar(
                    imageUrl: tutor.fotoUrl,
                    size: 56,
                    initials: tutor.nombre.substring(0, 2),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                tutor.nombre,
                                style: AppTextStyles.subtitle1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (tutor.verificado) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.verified,
                                  color: AppColors.primary, size: 16),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: AppColors.textHint),
                            const SizedBox(width: 2),
                            Text(tutor.ubicacion ?? '',
                                style: AppTextStyles.caption),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Materias
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: tutor.materias
                              .take(3)
                              .map(
                                (m) => ModalityBadge(modality: m),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                children: [
                  StarRating(rating: tutor.calificacionPromedio, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${tutor.calificacionPromedio} (${tutor.totalResenas})',
                    style: AppTextStyles.caption,
                  ),
                  const Spacer(),
                  Text(
                    '\$${tutor.tarifaPorHora.toStringAsFixed(0)}/hr',
                    style: AppTextStyles.price,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
