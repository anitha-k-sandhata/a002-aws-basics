package com.demo.orderservice.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class ProductClientService {

    @Value("${product.service.url}")
    private String productServiceUrl;

    private final RestTemplate restTemplate;

    public ProductClientService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public Object getProducts(){
        return restTemplate.getForObject(productServiceUrl, Object.class);
    }
}
