package com.campus.takeaway.dao;

import com.campus.takeaway.model.CartItem;
import com.campus.takeaway.model.Order;
import com.campus.takeaway.model.OrderItem;
import com.campus.takeaway.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class OrderDao {
    public int createOrder(Order order, Map<Integer, CartItem> cart) {
        String orderSql = "INSERT INTO orders(order_no, user_id, address_id, total_amount, status, remark) VALUES (?, ?, ?, ?, ?, ?)";
        String itemSql = "INSERT INTO order_items(order_id, dish_id, dish_name, price, quantity, subtotal) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement orderPs = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderPs.setString(1, order.getOrderNo());
                orderPs.setInt(2, order.getUserId());
                orderPs.setInt(3, order.getAddressId());
                orderPs.setBigDecimal(4, order.getTotalAmount());
                orderPs.setString(5, order.getStatus());
                orderPs.setString(6, order.getRemark());
                orderPs.executeUpdate();
                int orderId;
                try (ResultSet keys = orderPs.getGeneratedKeys()) {
                    keys.next();
                    orderId = keys.getInt(1);
                }

                try (PreparedStatement itemPs = conn.prepareStatement(itemSql)) {
                    for (CartItem cartItem : cart.values()) {
                        itemPs.setInt(1, orderId);
                        itemPs.setInt(2, cartItem.getDish().getId());
                        itemPs.setString(3, cartItem.getDish().getName());
                        itemPs.setBigDecimal(4, cartItem.getDish().getPrice());
                        itemPs.setInt(5, cartItem.getQuantity());
                        itemPs.setBigDecimal(6, cartItem.getSubtotal());
                        itemPs.addBatch();
                    }
                    itemPs.executeBatch();
                }
                conn.commit();
                return orderId;
            } catch (SQLException | RuntimeException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Order> findByUserId(int userId) {
        String sql = "SELECT o.*, u.real_name user_name, CONCAT(a.receiver_name, ' ', a.phone, ' ', a.detail) address_text " +
                "FROM orders o JOIN users u ON o.user_id = u.id JOIN addresses a ON o.address_id = a.id " +
                "WHERE o.user_id = ? ORDER BY o.id DESC";
        List<Order> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapOrder(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<Order> findAll() {
        String sql = "SELECT o.*, u.real_name user_name, CONCAT(a.receiver_name, ' ', a.phone, ' ', a.detail) address_text " +
                "FROM orders o JOIN users u ON o.user_id = u.id JOIN addresses a ON o.address_id = a.id ORDER BY o.id DESC";
        List<Order> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<OrderItem> findItems(int orderId) {
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        List<OrderItem> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setDishName(rs.getString("dish_name"));
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setSubtotal(rs.getBigDecimal("subtotal"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public void updateStatus(int id, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setOrderNo(rs.getString("order_no"));
        order.setUserId(rs.getInt("user_id"));
        order.setUserName(rs.getString("user_name"));
        order.setAddressDetail(rs.getString("address_text"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setRemark(rs.getString("remark"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        return order;
    }
}
