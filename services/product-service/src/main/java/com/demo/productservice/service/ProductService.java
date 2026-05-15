package com.demo.productservice.service;

import com.demo.productservice.model.Product;
import com.demo.productservice.repository.ProductRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @PostConstruct
    public void loadData() {

        if (productRepository.count() == 0) {

            productRepository.save(
                    new Product(1, "Laptop", 75000.0));

            productRepository.save(
                    new Product(2, "Phone", 30000.0));
        }
    }

    public List<Product> getProducts() {
        return productRepository.findAll();
    }
}