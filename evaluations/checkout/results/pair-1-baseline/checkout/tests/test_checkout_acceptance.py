import unittest

from checkout import accepts_payment, amount_due, discounted_total, shipping_cost, subtotal


class CheckoutAcceptanceTests(unittest.TestCase):
    def test_subtotal_quantities_and_empty_carts(self):
        for items, expected in [([], 0), ([(100, 0)], 0),
                                ([(1200, 3), (250, 2), (999, 0)], 4100)]:
            with self.subTest(items=items):
                self.assertEqual(subtotal(items), expected)

    def test_discount_endpoints_and_payable_rounding(self):
        for amount, percent, expected in [(0, 25, 0), (123, 0, 123),
                                          (123, 100, 0), (101, 50, 50),
                                          (999, 33, 669),
                                          (10**20 + 1, 50, 5 * 10**19)]:
            with self.subTest(amount=amount, percent=percent):
                self.assertEqual(discounted_total(amount, percent), expected)

    def test_delivery_boundary_and_pickup(self):
        for amount, expected in [(0, 500), (4999, 500), (5000, 0), (5001, 0)]:
            with self.subTest(amount=amount):
                self.assertEqual(shipping_cost(amount), expected)
                self.assertEqual(shipping_cost(amount, pickup=True), 0)

    def test_amount_due_uses_discounted_merchandise(self):
        for items, percent, pickup, expected in [
            ([(3000, 2)], 20, False, 5300),
            ([(3125, 2)], 20, False, 5000),
            ([(3000, 2)], 20, True, 4800),
            ([(101, 1)], 50, False, 550),
            ([(10000, 1)], 100, False, 500),
            ([], 0, False, 500),
            ([], 0, True, 0),
            ([(10000, 0)], 0, False, 500),
        ]:
            with self.subTest(items=items, percent=percent, pickup=pickup):
                due = amount_due(items, percent, pickup=pickup)
                self.assertEqual(due, expected)
                self.assertTrue(accepts_payment(expected, due))
                self.assertTrue(accepts_payment(expected + 1, due))
                if expected:
                    self.assertFalse(accepts_payment(expected - 1, due))

    def test_payment_boundaries(self):
        self.assertTrue(accepts_payment(0, 0))
        self.assertTrue(accepts_payment(1200, 1200))
        self.assertTrue(accepts_payment(1201, 1200))
        self.assertFalse(accepts_payment(1199, 1200))
