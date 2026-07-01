package com.campus.takeaway.dao;

import com.campus.takeaway.model.User;
import com.campus.takeaway.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDao {
    public User login(String username, String password) {
        String sql = "SELECT u.*, m.name merchant_name FROM users u LEFT JOIN merchants m ON u.merchant_id = m.id " +
                "WHERE u.username = ? AND u.password = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public boolean existsByUsername(String username) {
        String sql = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void register(User user) {
        String sql = "INSERT INTO users(username, password, real_name, phone, role) VALUES (?, ?, ?, ?, 'student')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRealName());
            ps.setString(4, user.getPhone());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<User> findAll() {
        String sql = "SELECT u.*, m.name merchant_name FROM users u LEFT JOIN merchants m ON u.merchant_id = m.id ORDER BY u.id DESC";
        List<User> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public void save(User user) {
        String sql = "INSERT INTO users(username, password, real_name, phone, role, merchant_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRealName());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            if (user.getMerchantId() == null) {
                ps.setNull(6, java.sql.Types.INTEGER);
            } else {
                ps.setInt(6, user.getMerchantId());
            }
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setRealName(rs.getString("real_name"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getString("role"));
        int merchantId = rs.getInt("merchant_id");
        user.setMerchantId(rs.wasNull() ? null : merchantId);
        try {
            user.setMerchantName(rs.getString("merchant_name"));
        } catch (SQLException ignored) {
            user.setMerchantName(null);
        }
        return user;
    }
}
