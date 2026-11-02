import 'package:flutter/material.dart';

void main() {
  runApp(const FoodOrderingApp());
}

// ============================================================
// MOCK AUTHENTICATION
// ============================================================
class MockAuth {
  static String currentName = 'Guest';
  static String currentEmail = 'guest@example.com';
}

// ============================================================
// FOOD MODEL
// ============================================================

class Food {
  String name;
  String category;
  double price;
  String description;
  double rating;
  IconData icon;

  Food({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.rating,
    required this.icon,
  });
}

// ============================================================
// CART ITEM MODEL
// ============================================================

class CartItem {
  Food food;
  int quantity;

  CartItem({
    required this.food,
    this.quantity = 1,
  });
}

// ============================================================
// APP
// ============================================================

class FoodOrderingApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  const FoodOrderingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Foodie',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.teal,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF2FAF8),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.teal,
            brightness: Brightness.dark,
          ),
          themeMode: currentMode,
          home: const LoginScreen(),
        );
      },
    );
  }
}

// ============================================================
// LOGIN SCREEN
// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  void login() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
        ),
      );
      return;
    }

    if (emailController.text.trim() != MockAuth.currentEmail) {
      MockAuth.currentEmail = emailController.text.trim();
      MockAuth.currentName = emailController.text.trim().split('@')[0];
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(
          userName: MockAuth.currentName,
          userEmail: MockAuth.currentEmail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.primary,
                    child: const Icon(
                      Icons.restaurant,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Foodie',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Delicious food delivered to you 🍔',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password reset feature coming soon'),
                          ),
                        );
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      onPressed: login,
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REGISTER SCREEN
// ============================================================

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void register() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    MockAuth.currentName = nameController.text.trim();
    MockAuth.currentEmail = emailController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                Icon(
                  Icons.person_add,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: register,
                    child: const Text('CREATE ACCOUNT'),
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

// ============================================================
// MAIN SCREEN
// ============================================================

class MainScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const MainScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  late String userName;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
    userEmail = widget.userEmail;
  }

  List<CartItem> cart = [];
  List<String> orderHistory = [];

  // ============================================================
  // 100 FOOD ITEMS (10 Categories, 10 Items Each)
  // ============================================================
  final List<Food> foods = [
    // 1. BREAKFAST (10)
    Food(name: 'Masala Poha', category: 'Breakfast', price: 60, rating: 4.3, description: 'Flattened rice tossed with mustard seeds, peanuts, and spices.', icon: Icons.breakfast_dining),
    Food(name: 'Aloo Paratha', category: 'Breakfast', price: 80, rating: 4.7, description: 'Stuffed flatbread with spiced potatoes, served with butter and curd.', icon: Icons.breakfast_dining),
    Food(name: 'Idli Sambar', category: 'Breakfast', price: 70, rating: 4.6, description: 'Soft steamed rice cakes served with lentil soup and coconut chutney.', icon: Icons.breakfast_dining),
    Food(name: 'Pancakes', category: 'Breakfast', price: 120, rating: 4.5, description: 'Fluffy pancakes drizzled with maple syrup and fresh berries.', icon: Icons.bakery_dining),
    Food(name: 'Masala Omelette', category: 'Breakfast', price: 90, rating: 4.4, description: 'Spicy Indian style omelette with onions, tomatoes, and green chilies.', icon: Icons.egg),
    Food(name: 'Avocado Toast', category: 'Breakfast', price: 150, rating: 4.8, description: 'Mashed avocado on toasted sourdough with chili flakes.', icon: Icons.breakfast_dining),
    Food(name: 'Upma', category: 'Breakfast', price: 60, rating: 4.2, description: 'Savory semolina porridge cooked with vegetables and curry leaves.', icon: Icons.breakfast_dining),
    Food(name: 'Waffles', category: 'Breakfast', price: 130, rating: 4.6, description: 'Crispy golden waffles topped with chocolate sauce and whipped cream.', icon: Icons.icecream),
    Food(name: 'French Toast', category: 'Breakfast', price: 110, rating: 4.5, description: 'Sweet bread soaked in eggs and milk, fried until golden.', icon: Icons.bakery_dining),
    Food(name: 'Masala Oats', category: 'Breakfast', price: 80, rating: 4.1, description: 'Healthy oats cooked with Indian spices and mixed vegetables.', icon: Icons.soup_kitchen),

    // 2. SNACKS (10)
    Food(name: 'Punjabi Samosa', category: 'Snacks', price: 50, rating: 4.5, description: 'Crispy pastry filled with spiced potatoes and peas.', icon: Icons.change_history),
    Food(name: 'Steamed Momos', category: 'Snacks', price: 120, rating: 4.8, description: 'Dumplings filled with veggies/chicken, served with spicy red chutney.', icon: Icons.local_dining),
    Food(name: 'Paneer Tikka', category: 'Snacks', price: 240, rating: 4.8, description: 'Marinated paneer cubes grilled perfectly in a tandoor.', icon: Icons.kebab_dining),
    Food(name: 'French Fries', category: 'Snacks', price: 100, rating: 4.4, description: 'Crispy golden fries salted to perfection.', icon: Icons.fastfood),
    Food(name: 'Spring Rolls', category: 'Snacks', price: 140, rating: 4.3, description: 'Crispy fried rolls stuffed with shredded vegetables.', icon: Icons.tapas),
    Food(name: 'Vada Pav', category: 'Snacks', price: 40, rating: 4.6, description: 'Spicy potato dumpling stuffed in a soft bread bun.', icon: Icons.fastfood),
    Food(name: 'Cheesy Nachos', category: 'Snacks', price: 160, rating: 4.7, description: 'Tortilla chips loaded with melted cheese, jalapeños, and salsa.', icon: Icons.local_pizza),
    Food(name: 'Onion Rings', category: 'Snacks', price: 110, rating: 4.2, description: 'Crispy battered and deep-fried onion rings.', icon: Icons.fastfood),
    Food(name: 'Bhel Puri', category: 'Snacks', price: 60, rating: 4.5, description: 'Sweet and tangy street snack made with puffed rice and chutneys.', icon: Icons.rice_bowl),
    Food(name: 'Chicken Nuggets', category: 'Snacks', price: 150, rating: 4.4, description: 'Bite-sized crispy fried chicken pieces with mayo dip.', icon: Icons.fastfood),

    // 3. PIZZA (10)
    Food(name: 'Margherita Pizza', category: 'Pizza', price: 250, rating: 4.7, description: 'Classic pizza with tomato sauce, mozzarella cheese, and fresh basil.', icon: Icons.local_pizza),
    Food(name: 'Farmhouse Pizza', category: 'Pizza', price: 350, rating: 4.6, description: 'Loaded with bell peppers, onions, tomatoes, and mushrooms.', icon: Icons.local_pizza),
    Food(name: 'Pepperoni Pizza', category: 'Pizza', price: 450, rating: 4.8, description: 'Classic cheesy pizza topped with spicy pepperoni slices.', icon: Icons.local_pizza),
    Food(name: 'Paneer Makhani Pizza', category: 'Pizza', price: 380, rating: 4.5, description: 'Fusion pizza featuring paneer makhani on a cheesy base.', icon: Icons.local_pizza),
    Food(name: 'BBQ Chicken Pizza', category: 'Pizza', price: 420, rating: 4.7, description: 'Topped with tender BBQ chicken bits, onions, and extra cheese.', icon: Icons.local_pizza),
    Food(name: 'Veg Supreme Pizza', category: 'Pizza', price: 390, rating: 4.4, description: 'Overloaded with all vegetable toppings and extra cheese.', icon: Icons.local_pizza),
    Food(name: 'Mushroom Truffle Pizza', category: 'Pizza', price: 480, rating: 4.9, description: 'Gourmet pizza with roasted mushrooms and truffle oil.', icon: Icons.local_pizza),
    Food(name: 'Hawaiian Pizza', category: 'Pizza', price: 360, rating: 4.1, description: 'Sweet and savory pizza with pineapple and ham.', icon: Icons.local_pizza),
    Food(name: 'Four Cheese Pizza', category: 'Pizza', price: 400, rating: 4.6, description: 'Rich pizza blended with Mozzarella, Cheddar, Parmesan, and Gouda.', icon: Icons.local_pizza),
    Food(name: 'Chicken Tikka Pizza', category: 'Pizza', price: 410, rating: 4.5, description: 'Spicy chicken tikka chunks over a classic cheese base.', icon: Icons.local_pizza),

    // 4. BURGERS (10)
    Food(name: 'Chicken Burger', category: 'Burgers', price: 180, rating: 4.5, description: 'Juicy chicken patty with fresh vegetables, cheese and special sauce.', icon: Icons.lunch_dining),
    Food(name: 'Veggie Tikki Burger', category: 'Burgers', price: 120, rating: 4.3, description: 'Crispy potato and pea patty packed with fresh greens and mayo.', icon: Icons.lunch_dining),
    Food(name: 'Double Cheese Burger', category: 'Burgers', price: 240, rating: 4.8, description: 'Two juicy meat patties layered with melting cheddar cheese.', icon: Icons.lunch_dining),
    Food(name: 'Spicy Zinger Burger', category: 'Burgers', price: 190, rating: 4.7, description: 'Extra crispy and spicy chicken fillet with lettuce and mayo.', icon: Icons.lunch_dining),
    Food(name: 'Mushroom Swiss Burger', category: 'Burgers', price: 210, rating: 4.6, description: 'Grilled beef patty topped with sautéed mushrooms and Swiss cheese.', icon: Icons.lunch_dining),
    Food(name: 'Crispy Paneer Burger', category: 'Burgers', price: 160, rating: 4.4, description: 'Thick, crunchy paneer patty layered with spicy sauce.', icon: Icons.lunch_dining),
    Food(name: 'BBQ Bacon Burger', category: 'Burgers', price: 260, rating: 4.9, description: 'Topped with crispy bacon, cheddar, and smoky BBQ sauce.', icon: Icons.lunch_dining),
    Food(name: 'Fish Fillet Burger', category: 'Burgers', price: 200, rating: 4.2, description: 'Golden fried fish fillet with tartar sauce and cheese.', icon: Icons.lunch_dining),
    Food(name: 'Aloo Tikki Burger', category: 'Burgers', price: 90, rating: 4.1, description: 'Simple street-style burger with a spiced potato patty.', icon: Icons.lunch_dining),
    Food(name: 'Black Bean Burger', category: 'Burgers', price: 170, rating: 4.5, description: 'Healthy and hearty black bean patty with vegan mayo.', icon: Icons.lunch_dining),

    // 5. CURRIES (10)
    Food(name: 'Butter Chicken', category: 'Curries', price: 320, rating: 4.9, description: 'Tender tandoori chicken cooked in a rich, mildly spiced tomato gravy.', icon: Icons.restaurant),
    Food(name: 'Palak Paneer', category: 'Curries', price: 260, rating: 4.5, description: 'Soft paneer cubes cooked in a smooth, spiced spinach gravy.', icon: Icons.eco),
    Food(name: 'Paneer Butter Masala', category: 'Curries', price: 280, rating: 4.8, description: 'Paneer cooked in a rich, buttery tomato and cashew gravy.', icon: Icons.local_dining),
    Food(name: 'Dal Makhani', category: 'Curries', price: 220, rating: 4.7, description: 'Slow-cooked black lentils enriched with butter and cream.', icon: Icons.soup_kitchen),
    Food(name: 'Chicken Tikka Masala', category: 'Curries', price: 340, rating: 4.6, description: 'Roasted marinated chicken chunks in a spiced curry sauce.', icon: Icons.set_meal),
    Food(name: 'Mutton Rogan Josh', category: 'Curries', price: 450, rating: 4.8, description: 'A deeply spiced, slow-cooked lamb curry from Kashmir.', icon: Icons.kebab_dining),
    Food(name: 'Chana Masala', category: 'Curries', price: 180, rating: 4.4, description: 'Spicy and tangy chickpea curry cooked with Indian spices.', icon: Icons.restaurant),
    Food(name: 'Malai Kofta', category: 'Curries', price: 290, rating: 4.7, description: 'Fried potato and paneer balls dunked in a creamy, sweet gravy.', icon: Icons.set_meal),
    Food(name: 'Fish Curry', category: 'Curries', price: 360, rating: 4.5, description: 'Tangy and spicy coastal style fish curry made with coconut.', icon: Icons.phishing),
    Food(name: 'Egg Curry', category: 'Curries', price: 170, rating: 4.2, description: 'Boiled eggs simmered in a spicy onion and tomato gravy.', icon: Icons.egg),

    // 6. INDIAN (10)
    Food(name: 'Masala Dosa', category: 'Indian', price: 150, rating: 4.7, description: 'Crispy rice crepe stuffed with spiced potatoes, served with sambar.', icon: Icons.breakfast_dining),
    Food(name: 'Chole Bhature', category: 'Indian', price: 180, rating: 4.6, description: 'Spicy chickpea curry served with fluffy, deep-fried bread.', icon: Icons.fastfood),
    Food(name: 'Chicken Biryani', category: 'Indian', price: 220, rating: 4.8, description: 'Aromatic basmati rice cooked with tender chicken and spices.', icon: Icons.rice_bowl),
    Food(name: 'Mutton Biryani', category: 'Indian', price: 350, rating: 4.9, description: 'Rich, flavorful rice dish layered with marinated mutton pieces.', icon: Icons.rice_bowl),
    Food(name: 'Tandoori Chicken', category: 'Indian', price: 300, rating: 4.7, description: 'Whole chicken marinated in yogurt and spices, roasted in a clay oven.', icon: Icons.kebab_dining),
    Food(name: 'Naan & Dal Fry', category: 'Indian', price: 140, rating: 4.5, description: 'Classic yellow lentil soup served with soft garlic naan.', icon: Icons.local_dining),
    Food(name: 'Pav Bhaji', category: 'Indian', price: 130, rating: 4.6, description: 'Mashed mixed vegetable curry served with butter-toasted buns.', icon: Icons.fastfood),
    Food(name: 'Chicken 65', category: 'Indian', price: 210, rating: 4.5, description: 'Spicy, deep-fried chicken bites tossed in curry leaves.', icon: Icons.local_fire_department),
    Food(name: 'Fish Fry', category: 'Indian', price: 250, rating: 4.4, description: 'Crispy, shallow-fried fish marinated with coastal spices.', icon: Icons.set_meal),
    Food(name: 'Uttapam', category: 'Indian', price: 110, rating: 4.3, description: 'Thick savory pancake topped with onions, tomatoes, and chilies.', icon: Icons.breakfast_dining),

    // 7. PASTA (10)
    Food(name: 'Penne Arrabbiata', category: 'Pasta', price: 240, rating: 4.5, description: 'Penne pasta tossed in a spicy, garlicky tomato sauce.', icon: Icons.restaurant),
    Food(name: 'Fettuccine Alfredo', category: 'Pasta', price: 280, rating: 4.7, description: 'Flat pasta ribbons coated in a rich, creamy parmesan sauce.', icon: Icons.dinner_dining),
    Food(name: 'Spaghetti Bolognese', category: 'Pasta', price: 320, rating: 4.8, description: 'Spaghetti served with a slow-cooked, rich minced meat sauce.', icon: Icons.restaurant_menu),
    Food(name: 'Mac & Cheese', category: 'Pasta', price: 200, rating: 4.6, description: 'Classic macaroni baked in a gooey, creamy cheddar cheese sauce.', icon: Icons.local_dining),
    Food(name: 'Pesto Pasta', category: 'Pasta', price: 260, rating: 4.5, description: 'Pasta coated in fresh basil pesto, garlic, pine nuts, and olive oil.', icon: Icons.eco),
    Food(name: 'Ravioli', category: 'Pasta', price: 350, rating: 4.8, description: 'Pasta parcels stuffed with spinach and ricotta in butter sage sauce.', icon: Icons.local_pizza),
    Food(name: 'Lasagna', category: 'Pasta', price: 380, rating: 4.9, description: 'Layers of flat pasta baked with meat sauce, béchamel, and cheese.', icon: Icons.layers),
    Food(name: 'Creamy Mushroom Pasta', category: 'Pasta', price: 270, rating: 4.6, description: 'Pasta cooked in a rich white wine and garlic mushroom cream sauce.', icon: Icons.restaurant),
    Food(name: 'Aglio e Olio', category: 'Pasta', price: 220, rating: 4.3, description: 'Spaghetti tossed simply in olive oil, garlic, and red pepper flakes.', icon: Icons.local_dining),
    Food(name: 'Seafood Pasta', category: 'Pasta', price: 420, rating: 4.7, description: 'Mixed seafood tossed with pasta in a light tomato and herb sauce.', icon: Icons.phishing),

    // 8. DESSERTS (10)
    Food(name: 'Chocolate Cake', category: 'Desserts', price: 140, rating: 4.6, description: 'Soft and delicious chocolate cake with creamy chocolate topping.', icon: Icons.cake),
    Food(name: 'Gulab Jamun', category: 'Desserts', price: 80, rating: 4.9, description: 'Warm, melt-in-your-mouth deep-fried dough balls in sugar syrup.', icon: Icons.cookie),
    Food(name: 'Rasmalai', category: 'Desserts', price: 120, rating: 4.8, description: 'Soft cottage cheese discs soaked in sweetened, cardamom milk.', icon: Icons.icecream),
    Food(name: 'Gajar Ka Halwa', category: 'Desserts', price: 150, rating: 4.7, description: 'Rich dessert made from grated carrots, milk, sugar, and ghee.', icon: Icons.ramen_dining),
    Food(name: 'Rasgulla', category: 'Desserts', price: 70, rating: 4.5, description: 'Spongy and syrupy Indian dessert made from cottage cheese.', icon: Icons.circle),
    Food(name: 'Ice Cream Sundae', category: 'Desserts', price: 180, rating: 4.6, description: 'Vanilla ice cream topped with chocolate syrup, nuts, and a cherry.', icon: Icons.icecream_outlined),
    Food(name: 'Brownie with Ice Cream', category: 'Desserts', price: 200, rating: 4.8, description: 'Warm, fudgy walnut brownie served with a scoop of vanilla ice cream.', icon: Icons.bakery_dining),
    Food(name: 'Tiramisu', category: 'Desserts', price: 250, rating: 4.9, description: 'Classic Italian coffee-flavored dessert layered with mascarpone.', icon: Icons.cake),
    Food(name: 'Cheesecake', category: 'Desserts', price: 220, rating: 4.7, description: 'Creamy New York style cheesecake with a graham cracker crust.', icon: Icons.pie_chart),
    Food(name: 'Jalebi', category: 'Desserts', price: 60, rating: 4.4, description: 'Crispy, spiraled deep-fried batter soaked in warm sugar syrup.', icon: Icons.motion_photos_auto),

    // 9. SALADS (10)
    Food(name: 'Fresh Green Salad', category: 'Salads', price: 120, rating: 4.1, description: 'Fresh vegetables mixed with a healthy and tasty dressing.', icon: Icons.eco),
    Food(name: 'Caesar Salad', category: 'Salads', price: 180, rating: 4.5, description: 'Romaine lettuce, croutons, and parmesan tossed in Caesar dressing.', icon: Icons.eco),
    Food(name: 'Greek Salad', category: 'Salads', price: 200, rating: 4.6, description: 'Cucumbers, tomatoes, olives, and feta cheese in olive oil dressing.', icon: Icons.eco),
    Food(name: 'Cobb Salad', category: 'Salads', price: 240, rating: 4.7, description: 'Mixed greens with chicken, bacon, eggs, avocado, and blue cheese.', icon: Icons.eco),
    Food(name: 'Caprese Salad', category: 'Salads', price: 220, rating: 4.6, description: 'Slices of fresh mozzarella, tomatoes, and sweet basil, seasoned with salt.', icon: Icons.eco),
    Food(name: 'Fruit Salad', category: 'Salads', price: 150, rating: 4.4, description: 'A refreshing mix of seasonal fresh fruits with a dash of honey.', icon: Icons.apple),
    Food(name: 'Quinoa Salad', category: 'Salads', price: 260, rating: 4.8, description: 'Healthy quinoa mixed with roasted veggies and a lemon vinaigrette.', icon: Icons.eco),
    Food(name: 'Macaroni Salad', category: 'Salads', price: 140, rating: 4.2, description: 'Cold pasta salad tossed in a creamy, tangy mayonnaise dressing.', icon: Icons.restaurant),
    Food(name: 'Asian Slaw', category: 'Salads', price: 130, rating: 4.3, description: 'Crunchy cabbage and carrots with a sesame ginger dressing.', icon: Icons.eco),
    Food(name: 'Sprouts Salad', category: 'Salads', price: 90, rating: 4.5, description: 'Nutritious mung bean sprouts mixed with onions, tomatoes, and lemon.', icon: Icons.spa),

    // 10. DRINKS (10)
    Food(name: 'Cold Coffee', category: 'Drinks', price: 130, rating: 4.5, description: 'Refreshing chilled coffee topped with creamy foam.', icon: Icons.local_cafe),
    Food(name: 'Mango Lassi', category: 'Drinks', price: 90, rating: 4.7, description: 'Sweet, creamy yogurt-based drink blended with fresh mango pulp.', icon: Icons.local_drink),
    Food(name: 'Masala Chai', category: 'Drinks', price: 40, rating: 4.8, description: 'Strong, aromatic Indian tea brewed with milk and crushed spices.', icon: Icons.coffee),
    Food(name: 'Virgin Mojito', category: 'Drinks', price: 110, rating: 4.6, description: 'Refreshing mocktail with mint leaves, lemon, sugar, and soda.', icon: Icons.local_bar),
    Food(name: 'Iced Tea', category: 'Drinks', price: 100, rating: 4.4, description: 'Chilled lemon-flavored black tea with ice.', icon: Icons.emoji_food_beverage),
    Food(name: 'Fresh Orange Juice', category: 'Drinks', price: 120, rating: 4.5, description: 'Freshly squeezed, no-sugar-added pure orange juice.', icon: Icons.local_drink),
    Food(name: 'Fresh Lemonade', category: 'Drinks', price: 60, rating: 4.3, description: 'Sweet and tangy traditional lemon water served chilled.', icon: Icons.local_drink),
    Food(name: 'Strawberry Shake', category: 'Drinks', price: 140, rating: 4.6, description: 'Thick milkshake blended with fresh strawberries and ice cream.', icon: Icons.icecream),
    Food(name: 'Hot Chocolate', category: 'Drinks', price: 150, rating: 4.7, description: 'Rich, thick, and creamy hot cocoa topped with marshmallows.', icon: Icons.coffee_maker),
    Food(name: 'Masala Buttermilk', category: 'Drinks', price: 50, rating: 4.4, description: 'Spiced, savory, and cooling yogurt drink (Chaas).', icon: Icons.local_drink),
  ];

  double getTotal() {
    double total = 0;
    for (CartItem item in cart) {
      total += item.food.price * item.quantity;
    }
    return total;
  }

  void addToCart(Food food) {
    int index = -1;
    for (int i = 0; i < cart.length; i++) {
      if (cart[i].food.name == food.name) {
        index = i;
        break;
      }
    }
    setState(() {
      if (index != -1) {
        cart[index].quantity++;
      } else {
        cart.add(CartItem(food: food, quantity: 1));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void increaseQuantity(int index) {
    setState(() {
      cart[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cart[index].quantity > 1) {
        cart[index].quantity--;
      } else {
        cart.removeAt(index);
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      cart.removeAt(index);
    });
  }

  void placeOrder() {
    if (cart.isEmpty) return;

    double total = getTotal();

    setState(() {
      orderHistory.add(
        'Order #${orderHistory.length + 1001} - ₹${total.toStringAsFixed(0)}',
      );
      cart.clear();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          orderNumber: orderHistory.length + 1000,
          total: total,
        ),
      ),
    );
  }

  void updateProfile(String name, String email) {
    setState(() {
      userName = name;
      userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    if (selectedIndex == 0) {
      currentPage = HomeScreen(
        userName: userName,
        foods: foods,
        onAddToCart: addToCart,
      );
    } else if (selectedIndex == 1) {
      currentPage = MenuScreen(
        foods: foods,
        onAddToCart: addToCart,
      );
    } else if (selectedIndex == 2) {
      currentPage = CartScreen(
        cart: cart,
        total: getTotal(),
        onIncrease: increaseQuantity,
        onDecrease: decreaseQuantity,
        onRemove: removeFromCart,
        onCheckout: () {
          if (cart.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Your cart is empty')),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutScreen(
                cart: cart,
                total: getTotal(),
                onPlaceOrder: placeOrder,
              ),
            ),
          );
        },
      );
    } else {
      currentPage = ProfileScreen(
        name: userName,
        email: userEmail,
        orderHistory: orderHistory,
        onUpdate: updateProfile,
      );
    }

    return Scaffold(
      body: currentPage,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cart.isNotEmpty,
              label: Text(cart.length.toString()),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: const Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatefulWidget {
  final String userName;
  final List<Food> foods;
  final Function(Food) onAddToCart;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.foods,
    required this.onAddToCart,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = '';
  String selectedCategory = 'All';

  List<String> categories = [
    'All', 'Breakfast', 'Indian', 'Curries', 'Snacks', 'Pizza', 'Burgers', 'Pasta', 'Desserts', 'Salads', 'Drinks',
  ];

  @override
  Widget build(BuildContext context) {
    List<Food> filteredFoods = widget.foods.where((food) {
      bool matchesSearch = food.name.toLowerCase().contains(searchText.toLowerCase());
      bool matchesCategory = selectedCategory == 'All' || food.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Foodie 🍔',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            int columns = 2;
            if (constraints.maxWidth >= 1100) columns = 4;
            else if (constraints.maxWidth >= 700) columns = 3;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${widget.userName}! 👋',
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'What would you like to eat today?',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search for food...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.tune),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        String category = categories[index];
                        bool selected = category == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: selected,
                            onSelected: (value) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular Food',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${filteredFoods.length} items',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredFoods.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      Food food = filteredFoods[index];
                      return FoodCard(
                        food: food,
                        onAdd: () => widget.onAddToCart(food),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// FOOD CARD
// ============================================================

class FoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback onAdd;

  const FoodCard({
    super.key,
    required this.food,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailsScreen(
                food: food,
                onAdd: onAdd,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    food.icon,
                    size: 65,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                food.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  Text(
                    ' ${food.rating}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    '₹${food.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                  ),
                  onPressed: onAdd,
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MENU SCREEN
// ============================================================

class MenuScreen extends StatefulWidget {
  final List<Food> foods;
  final Function(Food) onAddToCart;

  const MenuScreen({
    super.key,
    required this.foods,
    required this.onAddToCart,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = 'All';

  List<String> categories = [
    'All', 'Breakfast', 'Indian', 'Curries', 'Snacks', 'Pizza', 'Burgers', 'Pasta', 'Desserts', 'Salads', 'Drinks',
  ];

  @override
  Widget build(BuildContext context) {
    List<Food> filteredFoods = widget.foods.where((food) {
      return selectedCategory == 'All' || food.category == selectedCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Food Menu')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String category = categories[index];
                  bool selected = category == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      onSelected: (value) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int columns = 2;
                if (constraints.maxWidth >= 1100) columns = 4;
                else if (constraints.maxWidth >= 700) columns = 3;

                return GridView.builder(
                  padding: const EdgeInsets.all(18),
                  itemCount: filteredFoods.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return FoodCard(
                      food: filteredFoods[index],
                      onAdd: () => widget.onAddToCart(filteredFoods[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FOOD DETAILS SCREEN
// ============================================================

class FoodDetailsScreen extends StatefulWidget {
  final Food food;
  final VoidCallback onAdd;

  const FoodDetailsScreen({
    super.key,
    required this.food,
    required this.onAdd,
  });

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    double total = widget.food.price * quantity;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Food Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    widget.food.icon,
                    size: 120,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  widget.food.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(
                      ' ${widget.food.rating}',
                      style: const TextStyle(fontSize: 17),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      widget.food.category,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.food.description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() => quantity--);
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => quantity++),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      '₹${total.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        for (int i = 0; i < quantity; i++) {
                          widget.onAdd();
                        }
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CART SCREEN
// ============================================================

class CartScreen extends StatelessWidget {
  final List<CartItem> cart;
  final double total;

  final Function(int) onIncrease;
  final Function(int) onDecrease;
  final Function(int) onRemove;
  final VoidCallback onCheckout;

  const CartScreen({
    super.key,
    required this.cart,
    required this.total,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cart.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      CartItem item = cart[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  item.food.icon,
                                  size: 40,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.food.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text('₹${item.food.price.toStringAsFixed(0)}'),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => onDecrease(index),
                                          icon: const Icon(Icons.remove_circle_outline),
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => onIncrease(index),
                                          icon: const Icon(Icons.add_circle_outline),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => onRemove(index),
                                icon: Icon(
                                  Icons.delete,
                                  color: colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${total.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          onPressed: onCheckout,
                          child: const Text('PROCEED TO CHECKOUT'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// ============================================================
// CHECKOUT SCREEN
// ============================================================

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cart;
  final double total;
  final VoidCallback onPlaceOrder;

  const CheckoutScreen({
    super.key,
    required this.cart,
    required this.total,
    required this.onPlaceOrder,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final addressController = TextEditingController();
  String paymentMethod = 'Cash on Delivery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter your delivery address',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RadioListTile<String>(
                  value: 'Cash on Delivery',
                  groupValue: paymentMethod,
                  title: const Text('Cash on Delivery'),
                  secondary: const Icon(Icons.money),
                  onChanged: (value) => setState(() => paymentMethod = value!),
                ),
                RadioListTile<String>(
                  value: 'UPI',
                  groupValue: paymentMethod,
                  title: const Text('UPI'),
                  secondary: const Icon(Icons.phone_android),
                  onChanged: (value) => setState(() => paymentMethod = value!),
                ),
                RadioListTile<String>(
                  value: 'Card',
                  groupValue: paymentMethod,
                  title: const Text('Credit / Debit Card'),
                  secondary: const Icon(Icons.credit_card),
                  onChanged: (value) => setState(() => paymentMethod = value!),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...widget.cart.map(
                  (item) => ListTile(
                    title: Text(item.food.name),
                    subtitle: Text(
                      '${item.quantity} × ₹${item.food.price.toStringAsFixed(0)}',
                    ),
                    trailing: Text(
                      '₹${(item.quantity * item.food.price).toStringAsFixed(0)}',
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  trailing: Text(
                    '₹${widget.total.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      if (addressController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your address'),
                          ),
                        );
                        return;
                      }
                      widget.onPlaceOrder();
                    },
                    child: const Text(
                      'PLACE ORDER',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

// ============================================================
// ORDER SUCCESS SCREEN
// ============================================================

class OrderSuccessScreen extends StatelessWidget {
  final int orderNumber;
  final double total;

  const OrderSuccessScreen({
    super.key,
    required this.orderNumber,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    size: 65,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Order Placed!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your food is being prepared 🍔',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'Order #$orderNumber',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: ₹${total.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: 220,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        (route) => route.isFirst,
                      );
                    },
                    child: const Text('BACK TO HOME'),
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

// ============================================================
// PROFILE SCREEN
// ============================================================

class ProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  final List<String> orderHistory;
  final Function(String, String) onUpdate;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.orderHistory,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  email,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Card(
                  child: SwitchListTile(
                    title: const Text('Dark Mode'),
                    secondary: const Icon(Icons.dark_mode),
                    value: FoodOrderingApp.themeNotifier.value == ThemeMode.dark,
                    onChanged: (value) {
                      FoodOrderingApp.themeNotifier.value = 
                          value ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            name: name,
                            email: email,
                            onUpdate: onUpdate,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderHistoryScreen(
                            orders: orderHistory,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Order History'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(color: Theme.of(context).colorScheme.error),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
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

// ============================================================
// EDIT PROFILE SCREEN
// ============================================================

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final Function(String, String) onUpdate;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.onUpdate,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
  }

  void saveProfile() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    widget.onUpdate(
      nameController.text.trim(),
      emailController.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: saveProfile,
                    child: const Text(
                      'SAVE CHANGES',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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

// ============================================================
// ORDER HISTORY SCREEN
// ============================================================

class OrderHistoryScreen extends StatelessWidget {
  final List<String> orders;

  const OrderHistoryScreen({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: orders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.receipt,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Text(orders[index]),
                    subtitle: const Text('Order delivered'),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                );
              },
            ),
    );
  }
}