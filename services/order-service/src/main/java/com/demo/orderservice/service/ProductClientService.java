package com.demo.orderservice.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class ProductClientService {

    private final RestTemplate restTemplate;

    public ProductClientService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public Object getProducts(){
        String url = "http://product-service:8080/products";
//        String url = "http://localhost:8080/products";
        return restTemplate.getForObject(url, Object.class);
    }
}
