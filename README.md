# **🛒 Shopping List App**

The **Shopping List** app is a simple and easy-to-use Flutter application that helps you keep track of your grocery items effortlessly. Whether you're planning your weekly shopping or just need to jot down a few things, this app makes it quick and convenient to **add, edit, and organize** your items into categories.

---

## **✨ What You Can Do**

- **Add & Manage Items:** Quickly add items with their name, quantity, and category.
- **Organized Lists:** Items are neatly grouped into categories so you can find them easily.
- **Local Storage:** Your grocery lists are saved within the app, so you won’t lose them.

---

## **📁 How the App is Structured**

- **[main.dart](https://github.com/Yashwant1105/Shopping-list/blob/main/lib/main.dart)** - The starting point of the app, sets up the theme and user interface.
- **[grocery_list.dart](https://github.com/Yashwant1105/Shopping-list/blob/main/lib/widgets/grocery_list.dart)** - Displays all added grocery items and lets you remove them when needed.
- **[new_item.dart](https://github.com/Yashwant1105/Shopping-list/blob/main/lib/widgets/new_item.dart)** - The screen where you add new grocery items.
- **[category.dart](https://github.com/Yashwant1105/Shopping-list/blob/main/lib/models/category.dart)** - Defines the different categories available for your items.
- **[grocery_item.dart](https://github.com/Yashwant1105/Shopping-list/blob/main/lib/models/grocery_item.dart)** - Represents each individual grocery item in the app.
- **[categories.dart](https://github.com/Yashwant1105/Shopping-list/blob/main/lib/data/categories.dart)** - Contains a list of predefined categories with color codes for easy identification.

---

## **🔹 Flutter Features Used**

- **State Management:** Uses `StatefulWidget` and `setState` to handle updates.
- **Navigation & Routing:** Implements smooth screen transitions using `Navigator.push`.
- **Reusable UI Components:** Custom widgets make the app’s interface clean and modular.
- **Async Programming:** Uses `async/await` to manage tasks efficiently.

---

## **🚀 Getting Started**

### **Requirements**

Make sure you have these installed before running the app:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)

### **How to Run**

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Yashwant1105/Shopping-list.git
   cd Shopping-list
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Launch the App**:
   ```bash
   flutter run
   ```


