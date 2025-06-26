import 'package:flutter/material.dart';
import '../models/free_course.dart';
import '../services/free_course_service.dart';
import '../widgets/free_course_card.dart';

class FreeLiveCoursesPage extends StatefulWidget {
  const FreeLiveCoursesPage({Key? key}) : super(key: key);

  @override
  State<FreeLiveCoursesPage> createState() => _FreeLiveCoursesPageState();
}

class _FreeLiveCoursesPageState extends State<FreeLiveCoursesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<FreeCourse> _allCourses = [];
  List<FreeCourse> _filteredCourses = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _selectedLevel = 'All';
  bool _showLiveOnly = false;
  bool _isLoading = false;
  String? _error;

  final List<String> _levels = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() {
    super.initState();
    _loadCourses();
    _loadCategories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final courses = await FreeCourseService.fetchFreeLiveCourses(
        category: _selectedCategory != 'All' ? _selectedCategory : null,
        level: _selectedLevel != 'All' ? _selectedLevel : null,
        searchQuery: _searchController.text.isNotEmpty ? _searchController.text : null,
        liveOnly: _showLiveOnly,
      );

      setState(() {
        _allCourses = courses;
        _filteredCourses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _loadCategories() {
    setState(() {
      _categories = FreeCourseService.getCategories();
    });
  }

  void _filterCourses() {
    setState(() {
      _filteredCourses = _allCourses.where((course) {
        final matchesSearch = _searchController.text.isEmpty ||
            course.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            course.instructor.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            course.tags.any((tag) => tag.toLowerCase().contains(_searchController.text.toLowerCase()));

        final matchesCategory = _selectedCategory == 'All' || course.category == _selectedCategory;
        final matchesLevel = _selectedLevel == 'All' || course.level == _selectedLevel;
        final matchesLive = !_showLiveOnly || course.isLive;

        return matchesSearch && matchesCategory && matchesLevel && matchesLive;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'All';
      _selectedLevel = 'All';
      _showLiveOnly = false;
    });
    _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Free Live Health Courses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCourses,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCourses,
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilters(),
            _buildResultsInfo(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[400]!, Colors.green[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text(
                'FREE Health Courses',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Access premium health courses completely free! Learn about air quality, environmental health, and health technology from top experts.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildHeaderStat('${_allCourses.length}', 'Free Courses'),
              const SizedBox(width: 24),
              _buildHeaderStat('${_allCourses.where((c) => c.isLive).length}', 'Live Now'),
              const SizedBox(width: 24),
              _buildHeaderStat('100%', 'Free Forever'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String number, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withAlpha(230),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search free health courses...',
              prefixIcon: const Icon(Icons.search, color: Colors.green),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _searchController.clear(),
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.green[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.green[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
              filled: true,
              fillColor: Colors.green[50],
            ),
          ),
          const SizedBox(height: 16),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryFilter(),
                const SizedBox(width: 12),
                _buildLevelFilter(),
                const SizedBox(width: 12),
                _buildLiveFilter(),
                const SizedBox(width: 12),
                if (_hasActiveFilters()) _buildClearFiltersButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          items: _categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
            });
            _filterCourses();
          },
          icon: Icon(Icons.arrow_drop_down, color: Colors.green[700]),
        ),
      ),
    );
  }

  Widget _buildLevelFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLevel,
          items: _levels.map((level) {
            return DropdownMenuItem(
              value: level,
              child: Text(level, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedLevel = value!;
            });
            _filterCourses();
          },
          icon: Icon(Icons.arrow_drop_down, color: Colors.green[700]),
        ),
      ),
    );
  }

  Widget _buildLiveFilter() {
    return FilterChip(
      label: const Text('Live Only'),
      selected: _showLiveOnly,
      onSelected: (selected) {
        setState(() {
          _showLiveOnly = selected;
        });
        _filterCourses();
      },
      selectedColor: Colors.red[100],
      checkmarkColor: Colors.red,
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.green[300]!),
    );
  }

  Widget _buildClearFiltersButton() {
    return TextButton.icon(
      onPressed: _clearFilters,
      icon: const Icon(Icons.clear_all, size: 18),
      label: const Text('Clear All'),
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedCategory != 'All' ||
        _selectedLevel != 'All' ||
        _showLiveOnly ||
        _searchController.text.isNotEmpty;
  }

  Widget _buildResultsInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${_filteredCourses.length} free courses',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _allCourses.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_filteredCourses.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _filteredCourses.length,
      itemBuilder: (context, index) {
        final course = _filteredCourses[index];
        return FreeCourseCard(
          course: course,
          onTap: () => _onCourseSelected(course),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text(
              'Failed to load courses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCourses,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No free courses found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters to find more free courses.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCourseSelected(FreeCourse course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCoursePreview(course),
    );
  }

  Widget _buildCoursePreview(FreeCourse course) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${course.instructor} • ${course.institution}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Free badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'COMPLETELY FREE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'What you\'ll learn:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...course.learningOutcomes.map((outcome) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            outcome,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )),

                  const Spacer(),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              course.isLive
                                  ? 'Joining live session for ${course.title}'
                                  : 'Enrolled in ${course.title}',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: course.isLive ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        course.isLive ? 'Join Live Session Now' : 'Enroll for Free',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}