package com.demo.orderservice.model;

import lombok.Data;
import lombok.Value;

@Value
public class Order {
    String productId;
    Integer quantity;
}
