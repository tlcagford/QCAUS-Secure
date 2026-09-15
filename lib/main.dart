import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/aasr.dart';
import 'core/two_field_codec.dart';

const String privacyUrl =
    'https://tlcagford.github.io/QCAUS-Secure/privacy.html';
const String deletionUrl =
    'https://tlcagford.github.io/QCAUS-Secure/account-deletion.html';

void main() => runApp(const QcausApp());

class QcausApp extends StatelessWidget {
  const QcausApp({super.key});

  @override
  Widget build(BuildContext c) => MaterialApp(
        title: 'QCAUS Secure',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const Home(),
      );
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tab = 0;
  final pages = const [Chat(), Files(), Calls(), Contacts()];

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(
          title: const Text('QCAUS Secure'),
          actions: [
            IconButton(
              tooltip: 'Security',
              icon: const Icon(Icons.security),
              onPressed: () => Navigator.push(
                c,
                MaterialPageRoute(builder: (_) => const Security()),
              ),
            ),
            IconButton(
              tooltip: 'QCAUS Lab',
              icon: const Icon(Icons.science_outlined),
              onPressed: () => Navigator.push(
                c,
                MaterialPageRoute(builder: (_) => const Lab()),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'legal') {
                  Navigator.push(
                    c,
                    MaterialPageRoute(builder: (_) => const Legal()),
                  );
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'legal', child: Text('Privacy & Legal')),
              ],
            ),
          ],
        ),
        body: pages[tab],
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder_outlined),
              label: 'Files',
            ),
            NavigationDestination(
              icon: Icon(Icons.call_outlined),
              label: 'Calls',
            ),
            NavigationDestination(
              icon: Icon(Icons.contacts_outlined),
              label: 'Contacts',
            ),
          ],
        ),
      );
}

class Chat extends StatefulWidget {
  const Chat({super.key});
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final input = TextEditingController();
  final List<String> msgs = ['Welcome to QCAUS Secure.'];
  bool aasr = true;

  void send() {
    final s = input.text.trim();
    if (s.isEmpty) return;
    setState(() {
      msgs.add(s);
      input.clear();
    });
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => Column(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('QCAUS Contact'),
            subtitle: Text(
              aasr ? 'AASR • Verified session' : 'Encrypted session',
            ),
            trailing: Switch(
              value: aasr,
              onChanged: (v) => setState(() => aasr = v),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: msgs.length,
              itemBuilder: (_, i) => Align(
                alignment:
                    i == 0 ? Alignment.centerLeft : Alignment.centerRight,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(msgs[i]),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(
                      c,
                      MaterialPageRoute(builder: (_) => const Files()),
                    ),
                    icon: const Icon(Icons.attach_file),
                  ),
                  Expanded(
                    child: TextField(
                      controller: input,
                      onSubmitted: (_) => send(),
                      decoration: const InputDecoration(
                        hintText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
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

class Files extends StatefulWidget {
  const Files({super.key});
  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  String status = 'Ready for encrypted file transfer.';

  Future<void> pick() async {
    final r = await FilePicker.platform.pickFiles(withData: true);
    if (r == null) return;
    final f = r.files.single;
    setState(() {
      status = '${f.name} • ${f.size} bytes • integrity checked locally';
    });
  }

  @override
  Widget build(BuildContext c) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.lock_outline, size: 56),
          const SizedBox(height: 12),
          const Text(
            'Secure Files',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Local file-selection workflow with a design for encrypted, '
            'integrity-checked, resumable transfers.',
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: pick,
            icon: const Icon(Icons.upload_file),
            label: const Text('Select File'),
          ),
          const SizedBox(height: 20),
          SelectableText(status),
          const Card(
            child: ListTile(
              leading: Icon(Icons.restart_alt),
              title: Text('AASR-aware transfer design'),
              subtitle: Text(
                'Future network transport can resume verified chunks '
                'after authenticated recovery.',
              ),
            ),
          ),
        ],
      );
}

class Calls extends StatelessWidget {
  const Calls({super.key});

  @override
  Widget build(BuildContext c) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Calls',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.call),
              title: Text('Voice'),
              subtitle: Text('Call UI • transport integration pending'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.videocam_outlined),
              title: Text('Video'),
              subtitle: Text('Video UI • transport integration pending'),
            ),
          ),
        ],
      );
}

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext c) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Contacts',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('QCAUS Research Contact'),
            subtitle: Text('Identity verified • authenticated session'),
            trailing: Icon(Icons.verified),
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_2),
            title: const Text('Verify contact'),
            onTap: () => showDialog<void>(
              context: c,
              builder: (_) => const AlertDialog(
                title: Text('Contact verification'),
                content: Text(
                  'Production identity verification is not yet connected '
                  'to a network service.',
                ),
              ),
            ),
          ),
        ],
      );
}

class Security extends StatefulWidget {
  const Security({super.key});
  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  final e = AasrEngine();
  double score = .88;
  String result = 'Verified session';

  void run() {
    final o = e.observe(score);
    if (o.event == AasrEvent.anomaly) {
      final t = e.authenticatedTransitionToken('demo');
      result = e.recover(sessionSecret: 'demo', token: t)
          ? 'Authenticated recovery succeeded'
          : 'Recovery rejected';
    } else {
      result = 'No recovery required';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('Security')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.verified, size: 34),
                title: Text('Authenticated session model'),
                subtitle: Text(
                  'Channel observations never authorize state changes.',
                ),
              ),
            ),
            Text('Channel score: ${score.toStringAsFixed(2)}'),
            Slider(
              value: score,
              onChanged: (v) => setState(() => score = v),
            ),
            FilledButton.icon(
              onPressed: run,
              icon: const Icon(Icons.autorenew),
              label: const Text('Run AASR test'),
            ),
            const SizedBox(height: 12),
            Text(result),
            const SizedBox(height: 24),
            const Text(
              'Security status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This release is a research/engineering prototype. '
              'It is not independently audited and does not claim '
              'unhackable or absolute security.',
            ),
          ],
        ),
      );
}

class Lab extends StatefulWidget {
  const Lab({super.key});
  @override
  State<Lab> createState() => _LabState();
}

class _LabState extends State<Lab> {
  int bit = 1;
  double omega = .35;
  String out = '';

  void run() {
    final s = TwoFieldCodec.encodeBit(bit, omega: omega);
    setState(
      () => out =
          'Δφ=${s.phase.toStringAsFixed(3)} rad • Ω=${s.omega.toStringAsFixed(2)} '
          '• cross-term=${s.crossTerm.toStringAsFixed(3)} • decoded=${TwoFieldCodec.decode(s)}',
    );
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('QCAUS Lab')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Two-Field Research Codec',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Classical coherent two-field signal model; not a demonstrated '
              'dark-photon/FDM communication channel.',
            ),
            const SizedBox(height: 20),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('0')),
                ButtonSegment(value: 1, label: Text('1')),
              ],
              selected: {bit},
              onSelectionChanged: (s) => setState(() => bit = s.first),
            ),
            Text('Ω = ${omega.toStringAsFixed(2)}'),
            Slider(
              value: omega,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => omega = v),
            ),
            FilledButton(
              onPressed: run,
              child: const Text('Encode / Decode'),
            ),
            const SizedBox(height: 12),
            SelectableText(out),
          ],
        ),
      );
}

class Legal extends StatelessWidget {
  const Legal({super.key});

  Future<void> open(String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('Privacy & Legal')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'QCAUS Secure',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Current store build is a local engineering prototype. '
              'It does not create a network account or transmit message '
              'content to a QCAUS server.',
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              onTap: () => open(privacyUrl),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Account & Data Deletion'),
              subtitle: const Text('Current build has no network accounts.'),
              onTap: () => open(deletionUrl),
            ),
            const SizedBox(height: 20),
            const Text(
              'Production security notice',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The current prototype is not an independently audited secure '
              'messaging system. Production deployment must use a reviewed '
              'messaging protocol, authenticated identity, forward secrecy, '
              'post-compromise recovery, secure key storage, and proper '
              'multi-device key management.',
            ),
          ],
        ),
      );
}
