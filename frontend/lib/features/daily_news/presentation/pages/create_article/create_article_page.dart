import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/create/create_article_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/create/create_article_state.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_cubit.dart';

/// Page for creating, editing, and deleting news articles.
/// Handles form validation, image picking, and interaction with [CreateArticleCubit].
class CreateArticlePage extends StatefulWidget {
  final ArticleEntity? article;
  const CreateArticlePage({super.key, this.article});

  @override
  State<CreateArticlePage> createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  bool _isEditing = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      _isEditing = true;
      _titleController.text = widget.article!.title;
      _descriptionController.text = widget.article!.description;
      _contentController.text = widget.article!.content;
      _urlController.text = widget.article!.url ?? '';
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateArticleCubit>(),
      child: BlocConsumer<CreateArticleCubit, CreateArticleState>(
        listener: (context, state) {
          if (state is CreateArticleSuccess) {
            String message = "Noticia publicada exitosamente";
            if (_isDeleting) {
              message = "Noticia eliminada exitosamente";
            } else if (_isEditing) {
              message = "Noticia actualizada exitosamente";
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );

            if (!_isEditing) {
              _titleController.clear();
              _descriptionController.clear();
              _contentController.clear();
              _urlController.clear();
              setState(() {
                _image = null;
              });
            }

            context.read<RemoteArticlesCubit>().onGetArticles();
            if (_isEditing || _isDeleting) {
              Navigator.pop(context);
            }
          } else if (state is CreateArticleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_isEditing ? "Editar Noticia" : "Crear Noticia",
                  style: Theme.of(context).textTheme.titleLarge),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,
              iconTheme: Theme.of(context).appBarTheme.iconTheme,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              )
                            : (widget.article != null &&
                                    widget.article!.thumbnailUrl.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(
                                        widget.article!.thumbnailUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                      ),
                      child: (_image == null &&
                              (widget.article == null ||
                                  widget.article!.thumbnailUrl.isEmpty))
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo,
                                    size: 50, color: Colors.grey),
                                SizedBox(height: 8),
                                Text("Toca para agregar una imagen",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Título",
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Descripción",
                    ),
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: "URL Externa (Opcional)",
                      hintText: "https://ejemplo.com/noticia",
                    ),
                    keyboardType: TextInputType.url,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: "Contenido",
                      alignLabelWithHint: true,
                    ),
                    maxLines: 10,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state is CreateArticleLoading
                          ? null
                          : () {
                              if (_isEditing) {
                                context
                                    .read<CreateArticleCubit>()
                                    .updateArticle(
                                      originalArticle: widget.article!,
                                      title: _titleController.text,
                                      description: _descriptionController.text,
                                      content: _contentController.text,
                                      url: _urlController.text.isNotEmpty
                                          ? _urlController.text
                                          : null,
                                      image: _image,
                                    );
                              } else {
                                context
                                    .read<CreateArticleCubit>()
                                    .submitArticle(
                                      title: _titleController.text,
                                      description: _descriptionController.text,
                                      content: _contentController.text,
                                      url: _urlController.text.isNotEmpty
                                          ? _urlController.text
                                          : null,
                                      image: _image,
                                    );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state is CreateArticleLoading
                          ? CircularProgressIndicator(
                              color: Theme.of(context).scaffoldBackgroundColor)
                          : Text(
                              _isEditing ? "Actualizar" : "Publicar Noticia"),
                    ),
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is CreateArticleLoading
                            ? null
                            : () {
                                final cubit =
                                    context.read<CreateArticleCubit>();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Eliminar Noticia"),
                                    content: const Text(
                                        "¿Estás seguro de que quieres eliminar esta noticia?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancelar"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            _isDeleting = true;
                                          });
                                          cubit.deleteArticle(widget.article!);
                                        },
                                        child: const Text("Eliminar",
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Eliminar Noticia"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
