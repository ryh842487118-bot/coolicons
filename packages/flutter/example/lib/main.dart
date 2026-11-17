import 'package:coolicons_flutter/coolicons_flutter.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const CooliconsExampleApp());

class CooliconsExampleApp extends StatelessWidget {
  const CooliconsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coolicons Flutter',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B7CFA)),
        extensions: const [
          CoolIconsThemeData(
            style: CoolIconStyle.line,
            radius: CoolIconRadius.round,
            size: 28,
            strokeWidth: 2,
          ),
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF91A7FF),
          brightness: Brightness.dark,
        ),
        extensions: const [
          CoolIconsThemeData(
            style: CoolIconStyle.line,
            radius: CoolIconRadius.round,
            size: 28,
            strokeWidth: 2,
          ),
        ],
      ),
      home: const IconGalleryPage(),
    );
  }
}

class IconGalleryPage extends StatefulWidget {
  const IconGalleryPage({super.key});

  @override
  State<IconGalleryPage> createState() => _IconGalleryPageState();
}

class _IconGalleryPageState extends State<IconGalleryPage> {
  CoolIconStyle _style = CoolIconStyle.line;
  CoolIconRadius _radius = CoolIconRadius.round;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final icons = CoolIcons.all.entries
        .where((entry) => entry.key.contains(_query.toLowerCase()))
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      appBar: AppBar(title: const Text('Coolicons')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search icons',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<CoolIconStyle>(
                    initialValue: _style,
                    decoration: const InputDecoration(labelText: 'Style'),
                    items: CoolIconStyle.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _style = value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<CoolIconRadius>(
                    initialValue: _radius,
                    decoration: const InputDecoration(labelText: 'Corners'),
                    items: CoolIconRadius.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _radius = value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: icons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final entry = icons[index];
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CoolIcon(
                          entry.value,
                          style: _style,
                          radius: _radius,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            entry.key,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
