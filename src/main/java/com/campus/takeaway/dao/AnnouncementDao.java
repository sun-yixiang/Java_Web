package com.campus.takeaway.dao;

import com.campus.takeaway.model.Announcement;
import com.campus.takeaway.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDao {
    public List<Announcement> findLatest() {
        String sql = "SELECT * FROM announcements ORDER BY id DESC LIMIT 5";
        List<Announcement> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Announcement announcement = new Announcement();
                announcement.setId(rs.getInt("id"));
                announcement.setTitle(rs.getString("title"));
                announcement.setContent(rs.getString("content"));
                announcement.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(announcement);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }
}
