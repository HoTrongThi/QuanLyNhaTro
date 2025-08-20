# MoMo Payment Integration Guide

## Tổng quan
Hệ thống đã được tích hợp với MoMo Sandbox để tạo mã QR động cho thanh toán hóa đơn.

## Cài đặt

### 1. Chạy SQL Script
```sql
-- Chạy file database/add_momo_fields.sql để thêm các trường MoMo vào database
```

### 2. Cấu hình MoMo Credentials
Trong file `config/MoMoConfig.java`, cập nhật các thông tin:
- `PARTNER_CODE`: Mã đối tác MoMo
- `ACCESS_KEY`: Access Key từ MoMo
- `SECRET_KEY`: Secret Key từ MoMo
- `RETURN_URL`: URL người dùng được redirect sau thanh toán
- `NOTIFY_URL`: URL nhận thông báo IPN từ MoMo

### 3. Cập nhật URLs
Thay đổi domain trong `MoMoConfig.java` từ localhost sang domain thực tế:
```java
public static final String RETURN_URL = "https://yourdomain.com/QuanLyPhongTro/payment/momo/return";
public static final String NOTIFY_URL = "https://yourdomain.com/QuanLyPhongTro/payment/momo/notify";
```

## Tính năng

### 1. Tự động tạo QR Code
- Khi tạo hóa đơn thành công, hệ thống tự động gọi MoMo API để tạo QR code
- QR code được lưu vào database cùng với thông tin order

### 2. Hiển thị QR Code
- **User**: Thấy QR code trong chi tiết hóa đơn, có thể tải về hoặc tạo mới
- **Admin**: Thấy QR code và trạng thái thanh toán trong chi tiết hóa đơn

### 3. Xử lý Callback
- **Return URL**: Xử lý khi user được redirect từ MoMo
- **IPN URL**: Xử lý thông báo thanh toán từ MoMo

### 4. Trạng thái thanh toán
- `PENDING`: Đang chờ thanh toán
- `PAID`: Đã thanh toán thành công
- `FAILED`: Thanh toán thất bại

## API Endpoints

### MoMo Payment Controller
- `GET /payment/momo/return`: Xử lý return từ MoMo
- `POST /payment/momo/notify`: Xử lý IPN từ MoMo
- `POST /payment/momo/regenerate-qr/{invoiceId}`: Tạo QR code mới

## Database Schema

### Bảng invoices - Thêm các trường:
- `momo_qr_code_url`: URL của QR code
- `momo_order_id`: Order ID từ MoMo
- `momo_request_id`: Request ID từ MoMo
- `momo_payment_status`: Trạng thái thanh toán MoMo

### Bảng momo_payment_logs (Optional):
- Lưu log các giao dịch MoMo để tracking

## Testing với MoMo Sandbox

### 1. Credentials Sandbox
```
Partner Code: MOMO
Access Key: F8BBA842ECF85
Secret Key: K951B6PE1waDMi640xX08PD3vg6EkVlz
Endpoint: https://test-payment.momo.vn/v2/gateway/api/create
```

### 2. Test Flow
1. Tạo hóa đơn mới
2. Kiểm tra QR code được tạo
3. Sử dụng MoMo app để scan QR (sandbox)
4. Kiểm tra callback và cập nhật trạng thái

## Lưu ý Production

### 1. Security
- Validate signature trong IPN callback
- Sử dụng HTTPS cho tất cả URLs
- Bảo mật Secret Key

### 2. Error Handling
- Log tất cả giao dịch MoMo
- Xử lý timeout và retry
- Fallback khi MoMo service không khả dụng

### 3. Monitoring
- Monitor success rate của QR code generation
- Track payment completion rate
- Alert khi có lỗi MoMo API

## Troubleshooting

### 1. QR Code không tạo được
- Kiểm tra credentials MoMo
- Kiểm tra network connectivity
- Xem log trong console

### 2. Callback không hoạt động
- Kiểm tra URL có accessible từ internet
- Kiểm tra signature validation
- Xem MoMo dashboard để debug

### 3. Payment status không cập nhật
- Kiểm tra IPN URL
- Kiểm tra database connection
- Xem log trong MoMoPaymentController