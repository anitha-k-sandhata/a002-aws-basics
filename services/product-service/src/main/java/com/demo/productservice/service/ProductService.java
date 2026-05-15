package com.demo.productservice.service;

import com.demo.productservice.model.Product;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    public List<Product> getProducts() {

        return List.of(
                new Product(1, "Laptop", 75000.0),
                new Product(2, "Phone", 30000.0)
        );
    }
}
