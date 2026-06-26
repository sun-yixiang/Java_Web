package com.campus.takeaway.dao;

import com.campus.takeaway.model.Address;
import com.campus.takeaway.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AddressDao {
    public List<Address> findByUserId(int userId) {
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, id DESC";
        List<Address> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Address address = new Address();
                    address.setId(rs.getInt("id"));
                    address.setUserId(rs.getInt("user_id"));
                    address.setReceiverName(rs.getString("receiver_name"));
                    address.setPhone(rs.getString("phone"));
                    address.setDetail(rs.getString("detail"));
                    address.setDefaultAddress(rs.getInt("is_default") == 1);
                    list.add(address);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public void add(Address address) {
        String sql = "INSERT INTO addresses(user_id, receiver_name, phone, detail, is_default) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getReceiverName());
            ps.setString(3, address.getPhone());
            ps.setString(4, address.getDetail());
            ps.setInt(5, address.isDefaultAddress() ? 1 : 0);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
