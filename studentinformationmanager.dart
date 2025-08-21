import 'package:flutter/material.dart';

void main() => runApp(const StudentInfoApp());

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Information Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

/// Bottom-nav shell to host all required screens
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    WelcomeDashboard(),
    StudentCounter(),
    LoginForm(),
    ProfilePicture(),
  ];

  final _titles = const [
    'Dashboard',
    'Counter',
    'Login',
    'Profile Picture',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        centerTitle: true,
      ),
      body: SafeArea(child: _pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people_alt_outlined), label: 'Count'),
          NavigationDestination(icon: Icon(Icons.login), label: 'Login'),
          NavigationDestination(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}

/// a) Welcome Dashboard + Snackbar button
class WelcomeDashboard extends StatelessWidget {
  const WelcomeDashboard({super.key});

  final String studentName = 'John Doe';
  final String course = 'BSc. Computer Science';
  final String university = 'ABC University';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Student Information Manager',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                children: [
                  InfoRow(label: 'Name', value: studentName),
                  const SizedBox(height: 8),
                  InfoRow(label: 'Course', value: course),
                  const SizedBox(height: 8),
                  InfoRow(label: 'University', value: university),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Show Alert'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('Hello, $studentName! Welcome to the Student Info Manager.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            '$label:',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 7,
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

/// c) Student Counter with + / -
class StudentCounter extends StatefulWidget {
  const StudentCounter({super.key});

  @override
  State<StudentCounter> createState() => _StudentCounterState();
}

class _StudentCounterState extends State<StudentCounter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Count', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '$_count',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                IconButton.filledTonal(
                  icon: const Icon(Icons.remove),
                  tooltip: 'Decrease',
                  onPressed: () => setState(() => _count = (_count > 0) ? _count - 1 : 0),
                ),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  tooltip: 'Increase',
                  onPressed: () => setState(() => _count++),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  onPressed: () => setState(() => _count = 0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// d) Login form with validation
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Login successful for ${_emailCtrl.text}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Student Login', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// e) Profile picture from online URL, responsive
class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  final String imageUrl =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600&auto=format&fit=facearea&facepad=2';

  @override
  Widget build(BuildContext context) {
    // Size adapts to screen width
    final double size = (MediaQuery.of(context).size.width * 0.45).clamp(120, 220);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: size / 2,
            backgroundImage: NetworkImage(imageUrl),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(height: 16),
          Text(
            'Profile Picture (auto-resizes)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}