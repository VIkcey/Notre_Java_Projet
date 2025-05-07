package com.example.restaurant.dao;

import com.example.restaurant.model.MenuItem;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO {
    public List<MenuItem> getAllMenuItems() {
        List<MenuItem> items = new ArrayList<>();
        items.add(new MenuItem(1, "Pizza", 12.99, "Main"));
        items.add(new MenuItem(2, "Burger", 8.99, "Main"));
        items.add(new MenuItem(3, "Coke", 2.49, "Drink"));
        return items;
    }
}
