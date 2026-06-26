package com.campus.takeaway.model;

import java.math.BigDecimal;

public class CartItem {
    private Dish dish;
    private int quantity;

    public CartItem(Dish dish, int quantity) {
        this.dish = dish;
        this.quantity = quantity;
    }

    public Dish getDish() {
        return dish;
    }

    public void setDish(Dish dish) {
        this.dish = dish;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSubtotal() {
        return dish.getPrice().multiply(BigDecimal.valueOf(quantity));
    }
}
