import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:news_app_clean_architecture/config/theme/theme_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/profile/profile_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/profile/profile_state.dart';
import 'package:news_app_clean_architecture/injection_container.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/feed_item.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/navigation/navigation_service.dart';

/// Page that displays and manages the user's profile.
/// Allows editing profile details and viewing user's published/liked articles.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => sl<ProfileCubit>()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGender;
  bool _isEditing = false;
  final List<String> _genderOptions = [
    "Hombre",
    "Mujer",
    "No binario",
    "Prefiero no decirlo"
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    _nameController.text = state.name;
    _ageController.text = state.age;
    _selectedGender = state.gender.isNotEmpty ? state.gender : null;
  }

  @override
  Widget build(BuildContext context) {
    final isLight =
        context.watch<ThemeCubit>().state.brightness == Brightness.light;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mi Perfil"),
          actions: [
            IconButton(
              icon: Icon(
                context.watch<ThemeCubit>().state.brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await context.read<RemoteArticlesCubit>().onGetArticles();
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: BlocConsumer<ProfileCubit, ProfileState>(
                    listener: (context, state) {
                      if (!_isEditing) {
                        if (_nameController.text != state.name) {
                          _nameController.text = state.name;
                        }
                        if (_ageController.text != state.age) {
                          _ageController.text = state.age;
                        }
                        if (_selectedGender != state.gender) {
                          _selectedGender =
                              state.gender.isNotEmpty ? state.gender : null;
                        }
                      }
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap:
                                  _isEditing ? () => _pickImage(context) : null,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor:
                                    isLight ? Colors.black : Colors.white,
                                backgroundImage: state.imagePath != null
                                    ? FileImage(File(state.imagePath!))
                                    : null,
                                child: state.imagePath == null
                                    ? Icon(Icons.person,
                                        size: 60,
                                        color: isLight
                                            ? Colors.white
                                            : Colors.black)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (_isEditing)
                              const Text("Toca para cambiar foto"),
                            const SizedBox(height: 30),
                            _buildTextField(
                              controller: _nameController,
                              label: "Nombre",
                              icon: Icons.person_outline,
                              enabled: _isEditing,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _ageController,
                              label: "Edad",
                              icon: Icons.calendar_today,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              enabled: _isEditing,
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              value: _selectedGender,
                              decoration: InputDecoration(
                                labelText: "Género",
                                prefixIcon: const Icon(Icons.people_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabled: _isEditing,
                              ),
                              items: _genderOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: _isEditing
                                  ? (val) {
                                      if (val != null) {
                                        setState(() {
                                          _selectedGender = val;
                                        });
                                      }
                                    }
                                  : null,
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_isEditing) {
                                    // Guardar cambios
                                    context.read<ProfileCubit>().updateProfile(
                                          name: _nameController.text,
                                          age: _ageController.text,
                                          gender: _selectedGender,
                                        );
                                    setState(() {
                                      _isEditing = false;
                                    });
                                  } else {
                                    // Activar edición
                                    setState(() {
                                      _isEditing = true;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isLight
                                      ? Colors.black
                                      : Theme.of(context).colorScheme.primary,
                                  foregroundColor: isLight
                                      ? Colors.white
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  _isEditing
                                      ? "Guardar Cambios"
                                      : "Editar Perfil",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: isLight ? Colors.black : Colors.white,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: isLight ? Colors.black : Colors.white,
                      tabs: const [
                        Tab(text: "Mis Publicaciones"),
                        Tab(text: "Me Gusta"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                _buildMyArticlesList(context),
                _buildLikedArticlesList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyArticlesList(BuildContext context) {
    return BlocBuilder<RemoteArticlesCubit, RemoteArticlesState>(
      builder: (context, state) {
        if (state is RemoteArticlesDone) {
          final myArticles = state.articles!
              .where((article) =>
                  article.authorId == kUserId ||
                  article.authorName == 'Usuario Local')
              .toList();

          if (myArticles.isEmpty) {
            return const Center(child: Text("No has publicado nada aún."));
          }

          return ListView.builder(
            itemCount: myArticles.length,
            itemBuilder: (context, index) {
              final article = myArticles[index];
              return Stack(
                children: [
                  FeedItem(
                    article: article,
                    isList: true,
                    onArticlePressed: (article) {
                      Navigator.pushNamed(context, '/ArticleDetail',
                          arguments: article);
                    },
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          Navigator.pushNamed(context, '/CreateArticle',
                              arguments: article);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildLikedArticlesList(BuildContext context) {
    return BlocBuilder<RemoteArticlesCubit, RemoteArticlesState>(
      builder: (context, state) {
        if (state is RemoteArticlesDone) {
          final likedArticles = state.articles!
              .where((article) => article.likedIds.contains(kUserId))
              .toList();

          if (likedArticles.isEmpty) {
            return const Center(child: Text("No has dado like a nada aún."));
          }

          return ListView.builder(
            itemCount: likedArticles.length,
            itemBuilder: (context, index) {
              final article = likedArticles[index];
              return FeedItem(
                article: article,
                isList: true,
                onArticlePressed: (article) {
                  sl<NavigationService>().switchTab(0);
                  // Small delay to ensure the tab switch is processed and FeedScreen is ready
                  Future.delayed(const Duration(milliseconds: 300), () {
                    sl<NavigationService>().scrollToArticle(article);
                  });
                },
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (context.mounted) {
        context.read<ProfileCubit>().updateProfile(imagePath: pickedFile.path);
      }
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
