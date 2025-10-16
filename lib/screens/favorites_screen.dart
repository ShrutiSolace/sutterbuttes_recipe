import 'package:flutter/material.dart';
import '../repositories/favourites_repository.dart';
import '../modal/favourites_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Natural and Artisan Foods',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      body: const _HomeHeaderAndContent(),
    );
  }
}

class _HomeHeaderAndContent extends StatefulWidget {
  const _HomeHeaderAndContent();

  @override
  State<_HomeHeaderAndContent> createState() => _HomeHeaderAndContentState();
}

class _HomeHeaderAndContentState extends State<_HomeHeaderAndContent> {
  int _selectedChip = 0;

  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF7B8B57);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return FutureBuilder<FavouritesModel>(
      future: FavouritesRepository().getFavourites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Failed to load favourites'));
        }
        final favourites = snapshot.data;
        final recipeItems = favourites?.favorites?.recipes ?? <Recipes>[];
        final productItems = favourites?.favorites?.products ?? <Products>[];

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: const [
                  Icon(Icons.favorite, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    "My Favorites",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3D4D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (recipeItems.isNotEmpty) ...[
                const Text(
                  'Favorite Recipes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF4A3D4D)),
                ),
                const SizedBox(height: 10),
                GridView.builder(

                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipeItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75, // Adjust height/width ratio
                  ),
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final r = recipeItems[index];
                    return _FavoriteCard(
                      title: r.title ?? '',
                      imageUrl: r.image ?? '',
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],

              if (productItems.isNotEmpty) ...[
                const Text(
                  'Favorite Products',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF4A3D4D)),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75, // Adjust the height/width ratio
                  ),
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final p = productItems[index];
                    return _FavoriteCard(
                      title: p.title ?? '',
                      imageUrl: p.image ?? '',
                      subtitle: p.price != null ? '\$${p.price}' : null,
                    );
                  },
                ),

              ],
            ],
          ),
        );
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String? subtitle;

  const _FavoriteCard({required this.title, required this.imageUrl, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(  // Use Card instead of Container
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(  // Use Expanded instead of AspectRatio
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Container(color: const Color(0xFFF0F1F2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (subtitle != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
