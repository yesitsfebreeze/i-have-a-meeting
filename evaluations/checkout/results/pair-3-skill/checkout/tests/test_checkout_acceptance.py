import unittest

from checkout import accepts_payment, amount_due, discounted_total, shipping_cost, subtotal


class CheckoutAcceptanceTests(unittest.TestCase):
    def test_subtotal_quantities_and_empty_cart(self):
        for items, expected in [([], 0), ([(900, 0)], 0),
                                ([(1200, 3), (450, 2), (999, 0)], 4500)]:
            with self.subTest(items=items):
                self.assertEqual(subtotal(items), expected)

    def test_percentage_discount_rounds_payable_down(self):
        for amount, percent, expected in [(101, 10, 90), (999, 33, 669),
                                           (1234, 0, 1234), (1234, 100, 0),
                                           (0, 70, 0), (10**20 + 1, 1, 99 * 10**18)]:
            with self.subTest(amount=amount, percent=percent):
                self.assertEqual(discounted_total(amount, percent), expected)

    def test_shipping_threshold_and_pickup(self):
        for amount, expected in [(0, 500), (4999, 500), (5000, 0), (5001, 0)]:
            with self.subTest(amount=amount):
                self.assertEqual(shipping_cost(amount), expected)
                self.assertEqual(shipping_cost(amount, pickup=True), 0)

    def test_discounted_shipping_eligibility(self):
        for items, percent, delivery, pickup in [
            ([(3000, 2)], 20, 5300, 4800),
            ([(2500, 4)], 50, 5000, 5000),
            ([(10001, 1)], 50, 5000, 5000),
            ([(9999, 1)], 50, 5499, 4999),
            ([(9000, 1)], 100, 500, 0),
            ([], 0, 500, 0),
            ([(9000, 0)], 0, 500, 0),
        ]:
            with self.subTest(items=items, percent=percent):
                self.assertEqual(amount_due(items, percent), delivery)
                self.assertEqual(amount_due(items, percent, pickup=True), pickup)

    def test_payment_boundaries(self):
        for paid, due, expected in [(1199, 1200, False), (1200, 1200, True),
                                     (1201, 1200, True), (0, 0, True)]:
            with self.subTest(paid=paid, due=due):
                self.assertEqual(accepts_payment(paid, due), expected)

    def test_checkout_through_payment_acceptance(self):
        due = amount_due([(3000, 2), (999, 0)], 20)
        self.assertEqual(due, 5300)
        self.assertFalse(accepts_payment(5299, due))
        self.assertTrue(accepts_payment(5300, due))
        self.assertTrue(accepts_payment(5301, due))
