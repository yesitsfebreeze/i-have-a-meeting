FREE_SHIPPING_CENTS = 5000
SHIPPING_CENTS = 500


def subtotal(items):
    """Items are (unit_price_cents, quantity) pairs of nonnegative integers."""
    return sum(price * quantity for price, quantity in items)


def discounted_total(amount, percent):
    """Whole-cent amount after an integer percentage discount, rounded down."""
    return amount * (100 - percent) // 100


def shipping_cost(discounted_amount, *, pickup=False):
    """Pickup is free; delivery is free at the threshold, otherwise flat-rate."""
    if pickup:
        return 0
    return 0 if discounted_amount >= FREE_SHIPPING_CENTS else SHIPPING_CENTS


def amount_due(items, percent=0, *, pickup=False):
    amount = discounted_total(subtotal(items), percent)
    return amount + shipping_cost(amount, pickup=pickup)


def accepts_payment(paid, due):
    return paid >= due
