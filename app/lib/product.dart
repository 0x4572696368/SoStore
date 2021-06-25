import 'package:flutter/material.dart';

class Product {
  final String title, description;
  Image image;
  final int price, size, id;
  final Color color;
  Product({this.id, this.image, this.title, this.price, this.description, this.size, this.color});
}

List<Product> products = [];
