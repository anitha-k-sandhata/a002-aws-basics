package com.demo.orderservice.controller;

import com.demo.orderservice.model.Order;
import com.demo.orderservice.service.ProductClientService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController

public class OrderController {

    private final ProductClientService productClientService;

    public OrderController(ProductClientService productClientService) {
        this.productClientService = productClientService;
    }

    @GetMapping("/orders")
    public Map<String, Object> getOrders() {
        return Map.of(
                "orderId", 1001,
                "product", productClientService.getProducts(),
                "quantity", 1
        );
    }

}
