import unittest

from checkout import accepts_payment, amount_due, discounted_total, shipping_cost, subtotal


class CheckoutAcceptanceTests(unittest.TestCase):
    def test_subtotals_include_quantities(self):
        for items, expected in [([], 0), ([(1200, 0)], 0), ([(1200, 3), (750, 2), (900, 0)], 5100)]:
            with self.subTest(items=items):
                self.assertEqual(subtotal(items), expected)

    def test_discount_payable_amount_rounds_down(self):
        for amount, percent, expected in [(1200, 0, 1200), (1200, 25, 900), (101, 50, 50), (101, 1, 99), (1200, 100, 0), (0, 25, 0)]:
            with self.subTest(amount=amount, percent=percent):
                self.assertEqual(discounted_total(amount, percent), expected)

    def test_shipping_boundary_and_pickup(self):
        for amount, expected in [(0, 500), (4999, 500), (5000, 0), (5001, 0)]:
            with self.subTest(amount=amount):
                self.assertEqual(shipping_cost(amount), expected)
                self.assertEqual(shipping_cost(amount, pickup=True), 0)

    def test_checkout_through_payment_acceptance(self):
        cases = [
            ([(3000, 2)], 20, False, 5300),
            ([(2500, 4)], 50, False, 5000),
            ([(101, 3)], 50, True, 151),
            ([], 0, False, 500),
            ([], 0, True, 0),
            ([(6000, 0)], 0, False, 500),
            ([(6000, 1)], 100, False, 500),
        ]
        for items, percent, pickup, expected in cases:
            with self.subTest(items=items, percent=percent, pickup=pickup):
                due = amount_due(items, percent, pickup=pickup)
                self.assertEqual(due, expected)
                self.assertTrue(accepts_payment(expected, due))
                self.assertTrue(accepts_payment(expected + 1, due))
                if expected:
                    self.assertFalse(accepts_payment(expected - 1, due))

    def test_payment_boundary(self):
        for paid, due, expected in [(0, 0, True), (1199, 1200, False), (1200, 1200, True), (1201, 1200, True)]:
            with self.subTest(paid=paid, due=due):
                self.assertEqual(accepts_payment(paid, due), expected)
