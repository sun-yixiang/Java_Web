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
        String stockSql = "UPDATE dishes d JOIN merchants m ON d.merchant_id = m.id " +
                "SET d.stock = d.stock - ? WHERE d.id = ? AND d.stock >= ? AND d.status = 'on' AND m.status = 'open'";
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
                    try (PreparedStatement stockPs = conn.prepareStatement(stockSql)) {
                        for (CartItem cartItem : cart.values()) {
                            stockPs.setInt(1, cartItem.getQuantity());
                            stockPs.setInt(2, cartItem.getDish().getId());
                            stockPs.setInt(3, cartItem.getQuantity());
                            int updated = stockPs.executeUpdate();
                            if (updated == 0) {
                                throw new IllegalStateException(cartItem.getDish().getName() + " 库存不足，请返回购物车重新确认。");
                            }
                        }
                    }
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

    public List<Order> findByMerchantId(int merchantId) {
        String sql = "SELECT o.id, o.order_no, o.user_id, o.address_id, u.real_name user_name, " +
                "CONCAT(a.receiver_name, ' ', a.phone, ' ', a.detail) address_text, " +
                "SUM(oi.subtotal) total_amount, o.status, o.remark, o.created_at " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.id " +
                "JOIN addresses a ON o.address_id = a.id " +
                "JOIN order_items oi ON o.id = oi.order_id " +
                "JOIN dishes d ON oi.dish_id = d.id " +
                "WHERE d.merchant_id = ? " +
                "GROUP BY o.id, o.order_no, o.user_id, o.address_id, u.real_name, a.receiver_name, a.phone, a.detail, o.status, o.remark, o.created_at " +
                "ORDER BY o.id DESC";
        List<Order> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, merchantId);
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

    public List<OrderItem> findItemsByMerchantId(int orderId, int merchantId) {
        String sql = "SELECT oi.* FROM order_items oi JOIN dishes d ON oi.dish_id = d.id " +
                "WHERE oi.order_id = ? AND d.merchant_id = ?";
        List<OrderItem> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, merchantId);
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

    public void updateMerchantOrderStatus(int id, int merchantId, String status) {
        String sql = "UPDATE orders o SET o.status = ? WHERE o.id = ? AND EXISTS (" +
                "SELECT 1 FROM order_items oi JOIN dishes d ON oi.dish_id = d.id " +
                "WHERE oi.order_id = o.id AND d.merchant_id = ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.setInt(3, merchantId);
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
