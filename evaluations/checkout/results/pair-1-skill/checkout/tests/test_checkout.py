import unittest
from checkout import subtotal, discounted_total, shipping_cost, amount_due, accepts_payment

class CheckoutTests(unittest.TestCase):
    def test_single_item(self):
        self.assertEqual(subtotal([(1200, 1)]), 1200)

    def test_no_discount(self):
        self.assertEqual(discounted_total(1200, 0), 1200)

    def test_pickup(self):
        self.assertEqual(amount_due([(1200, 1)], pickup=True), 1200)

    def test_small_delivery(self):
        self.assertEqual(shipping_cost(1200), 500)

    def test_underpayment(self):
        self.assertFalse(accepts_payment(1199, 1200))
