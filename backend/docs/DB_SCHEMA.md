# Esquema de Base de Datos (Firestore) - Applicant Showcase App

## 1. Introducción

Este documento define el esquema de la base de datos NoSQL (Cloud Firestore) para la funcionalidad de 'Periodista' y el feed de noticias de la aplicación. El diseño sigue los principios de Clean Architecture delineados en `APP_ARCHITECTURE.md` y está optimizado para la escalabilidad y el rendimiento del frontend.

## 2. Colección: `articles`

Esta colección almacenará todos los artículos de noticias creados por los periodistas. Cada documento en esta colección representa un único artículo.

### Estructura del Documento

| Campo | Tipo de Dato | Descripción | Ejemplo |
| :--- | :--- | :--- | :--- |
| `id` | `String` | Identificador único del documento (autogenerado por Firestore). | `8f2nL3b...` |
| `title` | `String` | El título principal del artículo. Debe ser conciso y descriptivo. | `"Avances en IA Generativa"` |
| `content` | `String` | El cuerpo completo del artículo, formateado en Markdown. | `"### Subtítulo\n\nContenido..."` |
| `category` | `String` | Categoría principal del artículo. Se usará para filtros en el frontend. | `"Tecnología"` |
| `thumbnailUrl` | `String` | URL pública de la imagen de portada del artículo. | `"https://storage.googleapis.com/..."` |
| `url` | `String` | URL externa del artículo original (opcional). | `"https://example.com/news/123"` |
| `publishedAt` | `String` | Fecha y hora de publicación en formato ISO 8601. **Clave para el ordenamiento**. | `"2025-12-06T14:30:00Z"`|
| `author` | `Map` | Objeto embebido con información básica del autor para evitar joins. | `{ id: "uid123", name: "Jane Doe" ... }`|
| `stats` | `Map` | Objeto con métricas de interacción del artículo. | `{ likes: 1024 }` |
| `liked_by` | `Array<String>` | Lista de IDs de usuarios que han dado like al artículo. | `["user1", "user2"]` |

### Ejemplo Completo de un Documento (JSON)

```json
{
  "title": "Explorando los Límites de la Computación Cuántica",
  "content": "## Introducción\n\nLa computación cuántica promete revolucionar industrias enteras...\n\n*   Finanzas\n*   Medicina\n*   Inteligencia Artificial",
  "category": "Ciencia",
  "thumbnailUrl": "https://storage.googleapis.com/symmetry-showcase-app/media/articles/quantum_computing_thumbnail.png",
  "url": "https://science-news.com/quantum-computing",
  "publishedAt": "2025-11-20T10:00:00Z",
  "author": {
    "id": "user_journalist_001",
    "name": "Dr. Alan Grant",
    "avatar": "https://storage.googleapis.com/symmetry-showcase-app/media/avatars/alan_grant.png"
  },
  "stats": {
    "likes": 4096
  }
}
```

## 3. Decisiones de Diseño

Las siguientes decisiones se tomaron para garantizar un esquema robusto, escalable y alineado con las mejores prácticas de Firestore y los lineamientos de Symmetry.

### 3.1. Modelo NoSQL y Desnormalización

-   **Datos Embebidos (`author`)**: La información del autor (`id`, `name`, `avatar`) se embebe directamente en el documento del artículo. Esta desnormalización es una estrategia clave en NoSQL para optimizar las lecturas. Evita la necesidad de realizar una consulta adicional (un "join") para obtener los datos del autor cada vez que se carga un artículo en el feed, reduciendo la latencia y los costos de lectura de manera significativa.

### 3.2. Optimización para 'Lazy Loading' y Feed Infinito

-   **Campo `publishedAt`**: Este campo es fundamental para la implementación de un feed de noticias infinito y eficiente. El frontend realizará consultas paginadas ordenando los artículos de forma descendente por `publishedAt`.
-   **Estrategia de Paginación**: Para cargar más artículos, el cliente guardará el `publishedAt` del último artículo visible y lo usará como punto de partida (`startAfter`) para la siguiente consulta, asegurando una carga de datos fluida y sin duplicados.

### 3.3. Separación de Medios (Cloud Storage)

-   **Campo `thumbnailUrl`**: Las imágenes y otros archivos binarios pesados no se almacenan en Firestore para evitar exceder el límite de tamaño del documento (1 MiB) y para mantener los costos bajos. En su lugar, se suben a **Firebase Cloud Storage** y solo se almacena la URL de acceso público en el campo `thumbnailUrl`. La ruta sigue una convención clara (`media/articles/{articleId}`).

### 3.4. Alineación con Clean Architecture

-   Este esquema define la estructura del `ArticleModel` en la **Capa de Datos** de nuestra arquitectura. Este modelo extenderá la entidad `ArticleEntity` definida en la **Capa de Dominio**, la cual contendrá únicamente la lógica de negocio pura, sin dependencias de Firestore. El `ArticleRepositoryImpl` (Data Layer) será responsable de mapear los documentos de Firestore a instancias de `ArticleModel`.
