import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('add a sandwich to the cart and verify it is in the cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Initial state (order screen)
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Cart summary updated
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Go to cart screen
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('change sandwich type and add to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('modify quantity and add to cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap the quantity + button (NOT the cart icon)
      final addIcons = find.byIcon(Icons.add);
      await tester.tap(addIcons.first);
      await tester.pumpAndSettle();
      await tester.tap(addIcons.first);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('remove item from cart using delete button', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add one item to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Go to cart screen
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Delete the item
      final deleteIcon = find.byIcon(Icons.delete);
      expect(deleteIcon, findsWidgets);
      await tester.tap(deleteIcon.first);
      await tester.pumpAndSettle();

      // Cart should be empty
      expect(find.text('Your cart is empty.'), findsOneWidget);

      // Back to order screen and summary shows zero
      final backButton = find.widgetWithText(StyledButton, 'Back to Order');
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('decrement quantity to zero removes item', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      // Increase quantity to 2 on the order screen then add to cart.
      final addQuantityButton = find.widgetWithIcon(IconButton, Icons.add).first;
      await tester.ensureVisible(addQuantityButton);
      await tester.tap(addQuantityButton);
      await tester.pumpAndSettle();

      // Wait until the quantity label shows '2'
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(find.text('2'), findsOneWidget);

      final addToCartButton2 = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton2);
      await tester.tap(addToCartButton2);
      await tester.pumpAndSettle();

      // Go to cart and decrement twice (second remove removes the item)
      final viewCartButton2 = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton2);
      await tester.tap(viewCartButton2);
      await tester.pumpAndSettle();

      final removeIcon = find.byIcon(Icons.remove);
      expect(removeIcon, findsWidgets);

      // First decrement should change Qty from 2 -> 1
      await tester.tap(removeIcon.first);
      await tester.pumpAndSettle();
      expect(find.text('Qty: 1'), findsOneWidget);

      // Second decrement should remove the item entirely
      await tester.tap(removeIcon.first);
      await tester.pumpAndSettle();
      expect(find.text('Your cart is empty.'), findsOneWidget);
    });

    testWidgets('cart screen shows empty state and no checkout button', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Go to cart without adding anything
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty.'), findsOneWidget);
      // Checkout button should not be visible when cart empty
      expect(find.widgetWithText(StyledButton, 'Checkout'), findsNothing);
    });
  });
}
