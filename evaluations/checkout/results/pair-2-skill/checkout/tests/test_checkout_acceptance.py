import unittest

from checkout import subtotal, discounted_total, shipping_cost, amount_due, accepts_payment


class CheckoutAcceptanceTests(unittest.TestCase):
    def test_subtotal_quantities_and_empty_cart(self):
        for items, expected in [([], 0), ([(1200, 0)], 0),
                                ([(1200, 3), (499, 2), (800, 0)], 4598)]:
            with self.subTest(items=items):
                self.assertEqual(subtotal(items), expected)

    def test_discount_rounds_payable_amount_down(self):
        for amount, percent, expected in [(0, 50, 0), (1200, 0, 1200),
                                           (1200, 100, 0), (999, 15, 849),
                                           (1, 1, 0), (10001, 50, 5000),
                                           (10**20 + 1, 50, 5 * 10**19)]:
            with self.subTest(amount=amount, percent=percent):
                self.assertEqual(discounted_total(amount, percent), expected)

    def test_delivery_threshold_and_pickup(self):
        for amount, expected in [(0, 500), (4999, 500), (5000, 0), (5001, 0)]:
            with self.subTest(amount=amount):
                self.assertEqual(shipping_cost(amount), expected)
                self.assertEqual(shipping_cost(amount, pickup=True), 0)

    def test_shipping_uses_discounted_merchandise(self):
        self.assertEqual(amount_due([(3000, 2)], 20), 5300)
        self.assertEqual(amount_due([(3000, 2)], 20, pickup=True), 4800)
        self.assertEqual(amount_due([(2500, 4)], 50), 5000)
        self.assertEqual(amount_due([(10001, 1)], 50), 5000)
        self.assertEqual(amount_due([(6000, 1)], 100), 500)
        self.assertEqual(amount_due([]), 500)
        self.assertEqual(amount_due([], pickup=True), 0)
        self.assertEqual(amount_due([(7000, 0)]), 500)

    def test_payment_acceptance(self):
        for paid, due, accepted in [(1199, 1200, False), (1200, 1200, True),
                                    (1201, 1200, True), (0, 0, True), (0, 1, False)]:
            with self.subTest(paid=paid, due=due):
                self.assertEqual(accepts_payment(paid, due), accepted)

    def test_checkout_through_payment(self):
        due = amount_due([(2000, 3), (599, 2), (999, 0)], 35)
        self.assertEqual(due, 5178)
        self.assertFalse(accepts_payment(5177, due))
        self.assertTrue(accepts_payment(5178, due))
        self.assertTrue(accepts_payment(5179, due))
