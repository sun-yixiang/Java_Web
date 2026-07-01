package com.campus.takeaway.dao;

import com.campus.takeaway.model.Merchant;
import com.campus.takeaway.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class MerchantDao {
    public List<Merchant> findAll() {
        String sql = "SELECT * FROM merchants ORDER BY score DESC, id DESC";
        List<Merchant> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapMerchant(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public Merchant findById(int id) {
        String sql = "SELECT * FROM merchants WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapMerchant(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public void save(Merchant merchant) {
        if (merchant.getId() > 0) {
            update(merchant);
            return;
        }
        String sql = "INSERT INTO merchants(name, description, phone, address, status, score) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setMerchantParams(ps, merchant);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM merchants WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void update(Merchant merchant) {
        String sql = "UPDATE merchants SET name=?, description=?, phone=?, address=?, status=?, score=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setMerchantParams(ps, merchant);
            ps.setInt(7, merchant.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void setMerchantParams(PreparedStatement ps, Merchant merchant) throws SQLException {
        ps.setString(1, merchant.getName());
        ps.setString(2, merchant.getDescription());
        ps.setString(3, merchant.getPhone());
        ps.setString(4, merchant.getAddress());
        ps.setString(5, merchant.getStatus());
        ps.setBigDecimal(6, normalizeScore(merchant.getScore()));
    }

    private Merchant mapMerchant(ResultSet rs) throws SQLException {
        Merchant merchant = new Merchant();
        merchant.setId(rs.getInt("id"));
        merchant.setName(rs.getString("name"));
        merchant.setDescription(rs.getString("description"));
        merchant.setPhone(rs.getString("phone"));
        merchant.setAddress(rs.getString("address"));
        merchant.setStatus(rs.getString("status"));
        merchant.setScore(rs.getBigDecimal("score"));
        return merchant;
    }

    private BigDecimal normalizeScore(BigDecimal score) {
        if (score == null) {
            return BigDecimal.ZERO;
        }
        if (score.compareTo(BigDecimal.ZERO) < 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal max = new BigDecimal("5.0");
        if (score.compareTo(max) > 0) {
            return max;
        }
        return score;
    }
}
