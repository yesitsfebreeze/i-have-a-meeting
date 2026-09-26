import unittest

from checkout import accepts_payment, amount_due, discounted_total, shipping_cost, subtotal


class CheckoutAcceptanceTests(unittest.TestCase):
    def test_quantities_and_empty_carts(self):
        for items, expected in [([], 0), ([(1200, 0)], 0), ([(1200, 3), (250, 2), (999, 0)], 4100)]:
            with self.subTest(items=items):
                self.assertEqual(subtotal(items), expected)

    def test_percentage_and_floor_rounding(self):
        for amount, percent, expected in [(1200, 25, 900), (101, 50, 50), (1, 1, 0), (1200, 100, 0), (0, 33, 0), (10**20 + 1, 50, 5 * 10**19)]:
            with self.subTest(amount=amount, percent=percent):
                self.assertEqual(discounted_total(amount, percent), expected)

    def test_delivery_threshold_and_pickup(self):
        for amount, expected in [(0, 500), (4999, 500), (5000, 0), (5001, 0)]:
            with self.subTest(amount=amount):
                self.assertEqual(shipping_cost(amount), expected)
                self.assertEqual(shipping_cost(amount, pickup=True), 0)

    def test_shipping_uses_discounted_merchandise(self):
        for items, percent, expected in [([(3000, 2)], 25, 5000), ([(3125, 2)], 20, 5000), ([(6000, 1)], 100, 500), ([], 0, 500), ([(1200, 0)], 0, 500)]:
            with self.subTest(items=items, percent=percent):
                self.assertEqual(amount_due(items, percent), expected)
        self.assertEqual(amount_due([(3000, 2)], 25, pickup=True), 4500)
        self.assertEqual(amount_due([], pickup=True), 0)

    def test_payment_boundaries(self):
        for paid, due, expected in [(1199, 1200, False), (1200, 1200, True), (1201, 1200, True), (0, 0, True), (1, 0, True)]:
            with self.subTest(paid=paid, due=due):
                self.assertEqual(accepts_payment(paid, due), expected)

    def test_checkout_through_payment(self):
        due = amount_due([(2000, 3), (999, 0)], 25)
        self.assertEqual(due, 5000)
        self.assertFalse(accepts_payment(4999, due))
        self.assertTrue(accepts_payment(5000, due))
        self.assertTrue(accepts_payment(5001, due))
