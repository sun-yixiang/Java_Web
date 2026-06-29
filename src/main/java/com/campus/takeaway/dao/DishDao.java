package com.campus.takeaway.dao;

import com.campus.takeaway.model.Dish;
import com.campus.takeaway.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DishDao {
    public List<Dish> findAll(String keyword) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT d.*, m.name merchant_name, c.name category_name ");
        sql.append("FROM dishes d ");
        sql.append("JOIN merchants m ON d.merchant_id = m.id ");
        sql.append("JOIN categories c ON d.category_id = c.id ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("WHERE d.name LIKE ? OR m.name LIKE ? OR c.name LIKE ? ");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        sql.append("ORDER BY d.id DESC");

        List<Dish> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapDish(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<Dish> findAvailable(String keyword) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT d.*, m.name merchant_name, c.name category_name ");
        sql.append("FROM dishes d ");
        sql.append("JOIN merchants m ON d.merchant_id = m.id ");
        sql.append("JOIN categories c ON d.category_id = c.id ");
        sql.append("WHERE d.status = 'on' AND m.status = 'open' ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (d.name LIKE ? OR m.name LIKE ? OR c.name LIKE ?) ");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        sql.append("ORDER BY d.id DESC");

        List<Dish> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapDish(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public Dish findById(int id) {
        String sql = "SELECT d.*, m.name merchant_name, c.name category_name FROM dishes d " +
                "JOIN merchants m ON d.merchant_id = m.id JOIN categories c ON d.category_id = c.id WHERE d.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapDish(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public Dish findAvailableById(int id) {
        String sql = "SELECT d.*, m.name merchant_name, c.name category_name FROM dishes d " +
                "JOIN merchants m ON d.merchant_id = m.id JOIN categories c ON d.category_id = c.id " +
                "WHERE d.id = ? AND d.status = 'on' AND m.status = 'open'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapDish(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public void save(Dish dish) {
        if (dish.getId() > 0) {
            update(dish);
            return;
        }
        String sql = "INSERT INTO dishes(merchant_id, category_id, name, price, image_url, description, stock, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setDishParams(ps, dish);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM dishes WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void update(Dish dish) {
        String sql = "UPDATE dishes SET merchant_id=?, category_id=?, name=?, price=?, image_url=?, description=?, stock=?, status=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setDishParams(ps, dish);
            ps.setInt(9, dish.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void setDishParams(PreparedStatement ps, Dish dish) throws SQLException {
        ps.setInt(1, dish.getMerchantId());
        ps.setInt(2, dish.getCategoryId());
        ps.setString(3, dish.getName());
        ps.setBigDecimal(4, dish.getPrice());
        ps.setString(5, dish.getImageUrl());
        ps.setString(6, dish.getDescription());
        ps.setInt(7, dish.getStock());
        ps.setString(8, dish.getStatus());
    }

    private Dish mapDish(ResultSet rs) throws SQLException {
        Dish dish = new Dish();
        dish.setId(rs.getInt("id"));
        dish.setMerchantId(rs.getInt("merchant_id"));
        dish.setCategoryId(rs.getInt("category_id"));
        dish.setMerchantName(rs.getString("merchant_name"));
        dish.setCategoryName(rs.getString("category_name"));
        dish.setName(rs.getString("name"));
        dish.setPrice(rs.getBigDecimal("price"));
        dish.setImageUrl(rs.getString("image_url"));
        dish.setDescription(rs.getString("description"));
        dish.setStock(rs.getInt("stock"));
        dish.setStatus(rs.getString("status"));
        return dish;
    }
}
