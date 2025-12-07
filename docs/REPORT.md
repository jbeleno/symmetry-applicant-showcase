# Reporte de Desarrollo - Applicant Showcase App

## 1. Introducción
Al iniciar este proyecto, mi objetivo principal fue no solo cumplir con los requerimientos técnicos de una aplicación de noticias, sino crear una experiencia de usuario fluida y profesional que reflejara los estándares de calidad de Symmetry. Me encontré con una arquitectura limpia bien definida que sirvió como una excelente base para escalar la aplicación. Mi enfoque fue actuar como un ingeniero de software que valora tanto la robustez del código como la experiencia final del usuario.

## 2. Learning Journey
Aunque tenía conocimientos previos de Flutter, este proyecto me permitió profundizar en varios aspectos clave:

*   **Clean Architecture Estricta:** Aprendí a respetar rigurosamente las fronteras entre capas (Domain, Data, Presentation), asegurando que la lógica de negocio no dependiera de frameworks externos.
*   **Firebase Storage & Firestore:** Reforcé mis habilidades en el manejo de bases de datos NoSQL, específicamente en estrategias de desnormalización para optimizar lecturas (como embeber datos del autor).
*   **Flutter Bloc & Cubits:** Perfeccioné el manejo de estados complejos, especialmente al coordinar múltiples Cubits (`RemoteArticlesCubit`, `SearchArticleCubit`, `ProfileCubit`) y manejar actualizaciones optimistas en la UI.

Recursos utilizados:
*   Documentación oficial de Flutter y Bloc.
*   Tutoriales de Clean Architecture sugeridos en la documentación del proyecto.

## 3. Challenges Faced
*   **Sincronización de Listas (Feed vs. Búsqueda):** Uno de los mayores desafíos fue manejar la navegación entre el buscador y el feed. Al principio, al seleccionar una noticia buscada, la app intentaba localizarla en el feed principal (que es aleatorio), causando inconsistencias.
    *   *Solución:* Implementé lógica en el `RemoteArticlesCubit` para manejar dos listas separadas (`articles` para orden cronológico/búsqueda y `feedArticles` para el feed aleatorio) y ajusté la navegación para buscar en la lista correcta según el contexto.
*   **Manejo de Imágenes Rotas:** Algunas noticias de la API o creadas manualmente podían tener URLs de imagen inválidas, causando errores visuales.
    *   *Solución:* Implementé validaciones robustas en `FeedItem` y `CachedNetworkImage` para mostrar placeholders elegantes cuando las imágenes fallan o no existen.

## 4. Reflection and Future Directions
Este proyecto ha sido una excelente oportunidad para demostrar la capacidad de escribir código mantenible y escalable. He aprendido que una buena arquitectura al principio ahorra horas de depuración al final.

**Mejoras Futuras:**
*   Implementar caché local (Hive o Drift) para funcionamiento offline.
*   Añadir autenticación real con Firebase Auth (actualmente simulada con un ID fijo para demostración).
*   Implementar pruebas unitarias y de integración (TDD) para la lógica de negocio crítica.

## 5. Proof of the Project
La aplicación es completamente funcional, permitiendo:
1.  Ver un feed de noticias estilo TikTok (scroll vertical).
2.  Buscar noticias en tiempo real.
3.  Crear nuevos artículos con imágenes (subidas a Firebase Storage) y URLs externas.
4.  Editar el perfil de usuario y guardar cambios localmente.
5.  Dar "Like" a las noticias con feedback instantáneo (animación de doble toque).
6.  Compartir noticias a través de aplicaciones nativas.

**[Ver Videos Demostrativos del Funcionamiento (Google Drive)](https://drive.google.com/drive/folders/1YtIU8I4XEX1ui7eoLc0T9qgHSYPbB5gx?usp=sharing)**

## 6. Overdelivery
Siguiendo el valor de "Maximally Overdeliver", implementé varias características que van más allá de los requerimientos básicos:

### 1. Feed Aleatorio vs. Búsqueda Cronológica
*   **Descripción:** Mientras que el buscador muestra noticias ordenadas por fecha ("Lo último"), el feed principal ofrece una experiencia de descubrimiento aleatoria (`shuffle`), similar a redes sociales modernas.
*   **Implementación:** Modificación del `RemoteArticlesCubit` para mantener y gestionar dos estados de lista simultáneos sin duplicar llamadas a la API.

### 2. Modo Edición de Perfil Seguro
*   **Descripción:** En lugar de permitir la edición libre siempre, implementé un patrón de "Lectura/Edición". Los campos están bloqueados por defecto para prevenir cambios accidentales.
*   **Funcionalidad:** Un botón "Editar Perfil" habilita los campos y cambia a "Guardar Cambios". Se añadieron validaciones de tipo de dato (solo números para edad) y selectores (Dropdown para género).

### 3. Formato de Fechas Relativo ("Smart Dates") y Layout Optimizado
*   **Descripción:** Implementación de una utilidad `DateFormatter` que convierte fechas ISO 8601 en formatos legibles por humanos como "Hace 5 min", "Hace 2 horas" o "Ayer".
*   **UI Tweak:** Se reposicionó la fecha justo al lado del "Chip" de categoría en la tarjeta de noticias, mejorando la jerarquía visual y permitiendo una lectura rápida del contexto (Qué es y Cuándo pasó).

### 4. UI Polishing & Material 3
*   **Descripción:** Ajustes finos en la interfaz para una experiencia premium:
    *   Transparencia forzada en la `AppBar` para evitar el "tint" gris de Material 3 al hacer scroll.
    *   Placeholders animados (Shimmer effect) para la carga de imágenes.
    *   Uso consistente de la paleta de colores de Material 3.

### 5. Optimistic UI Updates
*   **Descripción:** Al dar "Like", la interfaz se actualiza instantáneamente antes de recibir la confirmación del servidor, proporcionando una experiencia de usuario mucho más rápida y responsiva. Si la petición falla, se revierte el cambio silenciosamente.

### 6. Animaciones Interactivas y Compartir
*   **Descripción:** Se implementó una animación de "doble tap" para dar like, mostrando un corazón animado en la posición exacta del toque, similar a Instagram/TikTok. Además, se integró la funcionalidad nativa de compartir contenido.
*   **Valor:** Aumenta el engagement y la viralidad del contenido, modernizando la experiencia de usuario.

### 7. Soporte Completo para URLs Externas
*   **Descripción:** Se extendió el esquema de datos y la UI de creación de artículos para permitir a los periodistas adjuntar enlaces a fuentes originales.
*   **Implementación:** Campo de texto dedicado en `CreateArticlePage` y lógica de navegación en el detalle del artículo para abrir el enlace en el navegador del sistema.

---

