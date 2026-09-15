import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/aasr.dart';
import 'core/two_field_codec.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QcausSecureApp());
}


class SecurityBetaBanner extends StatelessWidget {
  const SecurityBetaBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const SecurityBetaBanner(),
            Text('PUBLIC SECURITY BETA',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            const Text(
              'TRY TO BREAK IT. Test AASR, replay, MITM modification, '
              'downgrade, recovery, state rollback, and malformed-input paths.',
            ),
            const SizedBox(height: 8),
            const Text(
              'Research release — not for sensitive communications. '
              'The cryptographic implementation is not independently audited.',
            ),
          ],
        ),
      ),
    );
  }
}

class QcausSecureApp extends StatelessWidget {
  const QcausSecureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QCAUS Secure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: const HomeShell(),
      routes: {
        '/security': (_) => const SecurityPage(),
        '/lab': (_) => const LabPage(),
      },
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;
  final pages = const [
    ChatPage(),
    FilesPage(),
    CallsPage(),
    ContactsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QCAUS Secure'),
        actions: [
          IconButton(
            tooltip: 'Security',
            onPressed: () => Navigator.pushNamed(context, '/security'),
            icon: const Icon(Icons.security),
          ),
          IconButton(
            tooltip: 'QCAUS Lab',
            onPressed: () => Navigator.pushNamed(context, '/lab'),
            icon: const Icon(Icons.science),
          ),
        ],
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), label: 'Files'),
          NavigationDestination(icon: Icon(Icons.call_outlined), label: 'Calls'),
          NavigationDestination(icon: Icon(Icons.contacts_outlined), label: 'Contacts'),
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  final messages = <String>[];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void send() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add(text);
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: messages.isEmpty
              ? const Center(
                  child: Text(
                    'Local prototype chat\nNo network transport is enabled.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => Align(
                    alignment: Alignment.centerRight,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(messages[i]),
                      ),
                    ),
                  ),
                ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => send(),
                    decoration: const InputDecoration(
                      hintText: 'Prototype local message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: send,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  String status = 'No file selected.';

  Future<void> pick() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (!mounted || result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final bytes = file.bytes;
    setState(() {
      status = '${file.name} — ${file.size} bytes'
          '${bytes == null ? '' : ' — loaded in memory'}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Secure file workflow', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text(
            'The current build performs local file selection only. '
            'It does not upload or transfer files to a server.',
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: pick,
            icon: const Icon(Icons.attach_file),
            label: const Text('Select file'),
          ),
          const SizedBox(height: 12),
          Text(status),
        ],
      ),
    );
  }
}

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.call)),
            title: Text('Secure calls'),
            subtitle: Text('UI prototype — no production call transport configured.'),
          ),
          ListTile(
            leading: Icon(Icons.videocam_outlined),
            title: Text('Video'),
            subtitle: Text('Reserved for a separately reviewed media/transport stack.'),
          ),
        ],
      );
}

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Contacts'),
            subtitle: Text('Local prototype contact UI.'),
          ),
          ListTile(
            leading: Icon(Icons.person_add_alt_1),
            title: Text('Add contact'),
            subtitle: Text('Network identity binding is not implemented in v0.1.0.'),
          ),
        ],
      );
}

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  late final AasrEngine engine;

  @override
  void initState() {
    super.initState();
    engine = AasrEngine();
  }

  @override
  Widget build(BuildContext context) {
    final state = engine.state;
    return Scaffold(
      appBar: AppBar(title: const Text('Security / AASR')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                state.compromised ? Icons.warning : Icons.verified_user,
              ),
              title: Text('State: ${state.phase}'),
              subtitle: Text('Epoch ${state.epoch}'),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'AASR rejects unauthenticated state transitions. It is an '
            'application-layer guard and does not replace authenticated '
            'encryption or a reviewed secure-messaging protocol.',
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              setState(() {
                engine.transition(
                  token: 'attacker-token',
                  nextPhase: 'RECOVERY_REQUIRED',
                  reason: 'Simulated MITM-modified transition',
                );
              });
            },
            child: const Text('Test rejected transition'),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                engine.transition(
                  token: engine.authenticatedToken,
                  nextPhase: 'RECOVERY_REQUIRED',
                  reason: 'Operator-requested recovery',
                );
              });
            },
            child: const Text('Enter recovery state'),
          ),
          FilledButton.tonal(
            onPressed: () {
              setState(() => engine.recover(engine.authenticatedToken));
            },
            child: const Text('Authenticated recovery'),
          ),
          const SizedBox(height: 20),
          const Text('Event log', style: TextStyle(fontWeight: FontWeight.bold)),
          ...engine.events.reversed.map(
            (e) => ListTile(
              dense: true,
              title: Text('${e.type} — ${e.detail}'),
              subtitle: Text(e.timestamp.toIso8601String()),
            ),
          ),
        ],
      ),
    );
  }
}

class LabPage extends StatefulWidget {
  const LabPage({super.key});

  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  final codec = const TwoFieldCodec();
  final omegaController = TextEditingController(text: '0.20');
  final inputController = TextEditingController(text: '01001101');
  String result = '';

  @override
  void dispose() {
    omegaController.dispose();
    inputController.dispose();
    super.dispose();
  }

  void runCodec() {
    try {
      final bits = inputController.text
          .trim()
          .split('')
          .map(int.parse)
          .toList();
      final omega = double.parse(omegaController.text);
      final encoded = codec.encodeBpsk(bits, omega: omega);
      final decoded = codec.decodeBpsk(encoded, omega: omega);
      setState(() {
        result = const JsonEncoder.withIndent('  ').convert({
          'input_bits': bits,
          'omega': omega,
          'encoded_intensity': encoded,
          'decoded_bits': decoded,
          'round_trip_ok': bits.join() == decoded.join(),
        });
      });
    } catch (e) {
      setState(() => result = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('QCAUS Lab — Two-Field DSP')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Classical coherent two-field/DSP demonstration. '
              'This does not demonstrate dark-photon/FDM coupling, '
              'entanglement, FTL communication, or reactionless communication.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: inputController,
              decoration: const InputDecoration(
                labelText: 'BPSK bits',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: omegaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Omega cross-term weight',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: runCodec,
              child: const Text('Encode / decode'),
            ),
            const SizedBox(height: 16),
            SelectableText(result.isEmpty ? 'No result yet.' : result),
          ],
        ),
      );
}

/// Keeps imports needed by the prototype's future secure-storage path explicit.
/// No secret is persisted by the current UI.
Future<void> _storageSmokeTest() async {
  const storage = FlutterSecureStorage();
  await storage.read(key: 'qcaus_secure_smoke_test');
  final prefs = await SharedPreferences.getInstance();
  await prefs.getBool('qcaus_secure_smoke_test');
}
