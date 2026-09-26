import unittest

from checkout import accepts_payment, amount_due, discounted_total, shipping_cost, subtotal


class CheckoutAcceptanceTests(unittest.TestCase):
    def test_subtotal_quantities(self):
        for items, expected in [([], 0), ([(1200, 0)], 0),
                                ([(1200, 3), (250, 2), (999, 0)], 4100)]:
            with self.subTest(items=items):
                self.assertEqual(subtotal(items), expected)

    def test_discount_rounding_and_endpoints(self):
        for amount, percent, expected in [(1234, 0, 1234), (1234, 100, 0),
                                          (0, 50, 0), (101, 50, 50),
                                          (999, 15, 849), (6000, 25, 4500)]:
            with self.subTest(amount=amount, percent=percent):
                self.assertEqual(discounted_total(amount, percent), expected)

    def test_large_cent_values_remain_exact(self):
        self.assertEqual(discounted_total(100000000000000001, 50),
                         50000000000000000)

    def test_delivery_threshold_and_pickup(self):
        for amount, expected in [(0, 500), (4999, 500), (5000, 0), (5001, 0)]:
            with self.subTest(amount=amount):
                self.assertEqual(shipping_cost(amount), expected)
                self.assertEqual(shipping_cost(amount, pickup=True), 0)

    def test_amount_due_uses_discounted_merchandise(self):
        for items, percent, delivery_due, pickup_due in [
            ([(3000, 2)], 25, 5000, 4500),
            ([(3125, 2)], 20, 5000, 5000),
            ([(5001, 1)], 0, 5001, 5001),
            ([(5000, 1)], 100, 500, 0),
            ([(101, 3)], 50, 651, 151),
            ([], 0, 500, 0),
            ([(6000, 0)], 0, 500, 0),
        ]:
            with self.subTest(items=items, percent=percent):
                self.assertEqual(amount_due(items, percent), delivery_due)
                self.assertEqual(amount_due(items, percent, pickup=True), pickup_due)

    def test_payment_acceptance_boundaries(self):
        for paid, due, expected in [(1199, 1200, False), (1200, 1200, True),
                                    (1201, 1200, True), (0, 0, True),
                                    (1, 0, True), (0, 1, False)]:
            with self.subTest(paid=paid, due=due):
                self.assertEqual(accepts_payment(paid, due), expected)

    def test_checkout_through_payment(self):
        due = amount_due([(3000, 2), (999, 0)], 25)
        self.assertEqual(due, 5000)
        self.assertFalse(accepts_payment(4999, due))
        self.assertTrue(accepts_payment(5000, due))
        self.assertTrue(accepts_payment(5001, due))
