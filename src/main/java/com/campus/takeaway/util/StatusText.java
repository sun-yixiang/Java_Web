package com.campus.takeaway.util;

public final class StatusText {
    private StatusText() {
    }

    public static String merchant(String status) {
        if ("open".equals(status)) {
            return "营业中";
        }
        if ("closed".equals(status)) {
            return "已关闭";
        }
        return status == null ? "" : status;
    }

    public static String dish(String status) {
        if ("on".equals(status)) {
            return "已上架";
        }
        if ("off".equals(status)) {
            return "已下架";
        }
        return status == null ? "" : status;
    }

    public static String order(String status) {
        if ("created".equals(status)) {
            return "待处理";
        }
        if ("paid".equals(status)) {
            return "已支付";
        }
        if ("delivering".equals(status)) {
            return "配送中";
        }
        if ("finished".equals(status)) {
            return "已完成";
        }
        if ("cancelled".equals(status)) {
            return "已取消";
        }
        return status == null ? "" : status;
    }
}
