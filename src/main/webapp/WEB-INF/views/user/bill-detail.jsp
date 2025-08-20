<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Quản lý Phòng trọ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            min-height: 100vh;
            color: white;
        }
        
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            margin: 2px 0;
        }
        
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }
        
        .main-content {
            background: #f8f9fa;
            min-height: 100vh;
        }
        
        .navbar {
            background: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        
        .invoice-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px 15px 0 0;
        }
        
        .invoice-info {
            background: linear-gradient(135deg, #e8f5e8, #f0fff4);
            border-radius: 10px;
            border-left: 4px solid #28a745;
        }
        
        .cost-breakdown-card {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .cost-breakdown-card:hover {
            border-color: #28a745;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.15);
        }
        
        .badge-paid {
            background: linear-gradient(135deg, #28a745, #20c997);
        }
        
        .badge-unpaid {
            background: linear-gradient(135deg, #dc3545, #fd7e14);
        }
        
        .btn-custom {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            border-radius: 10px;
            color: white;
        }
        
        .btn-custom:hover {
            background: linear-gradient(135deg, #20c997 0%, #28a745 100%);
            color: white;
        }
        
        .total-amount {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border-radius: 10px;
        }
        
        .service-item, .additional-cost-item {
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 3px solid #28a745;
        }
        
        .payment-reminder {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            border: 1px solid #ffc107;
            border-radius: 10px;
        }
        
        .print-button {
            background: linear-gradient(135deg, #17a2b8, #007bff);
            border: none;
            border-radius: 10px;
            color: white;
        }
        
        .print-button:hover {
            background: linear-gradient(135deg, #007bff, #17a2b8);
            color: white;
        }
        
        @media print {
            .sidebar, .print-button, .btn-custom {
                display: none !important;
            }
            .main-content {
                margin: 0 !important;
                padding: 0 !important;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <div class="p-3">
                    <h4 class="text-center mb-4">
                        <i class="bi bi-house-door me-2"></i>
                        Phòng trọ
                    </h4>
                    
                    <div class="text-center mb-4">
                        <div class="bg-light text-dark rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 60px; height: 60px;">
                            <i class="bi bi-person-circle fs-3"></i>
                        </div>
                        <div class="mt-2">
                            <strong>${user.fullName}</strong>
                            <br>
                            <small class="text-light">Người thuê</small>
                        </div>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/dashboard">
                            <i class="bi bi-speedometer2 me-2"></i>
                            Bảng điều khiển
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/profile">
                            <i class="bi bi-person me-2"></i>
                            Thông tin cá nhân
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/room">
                            <i class="bi bi-house-door me-2"></i>
                            Thông tin Phòng
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/user/bills">
                            <i class="bi bi-receipt me-2"></i>
                            Hóa đơn của tôi
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/payments">
                            <i class="bi bi-credit-card me-2"></i>
                            Lịch sử Thanh toán
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/messages">
                            <i class="bi bi-chat-dots me-2"></i>
                            Tin nhắn
                        </a>
                        <hr class="text-light">
                        <a class="nav-link text-warning" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-2"></i>
                            Đăng xuất
                        </a>
                    </nav>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content">
                <!-- Top Navigation -->
                <nav class="navbar navbar-expand-lg navbar-light">
                    <div class="container-fluid">
                        <h5 class="navbar-brand mb-0">${pageTitle}</h5>
                        <div class="navbar-nav ms-auto">
                            <div class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle me-1"></i>
                                    ${user.fullName}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">Thông tin cá nhân</a></li>
                                    <li><a class="dropdown-item" href="#">Cài đặt</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>
                
                <!-- Invoice Detail Content -->
                <div class="p-4">
                    <!-- Print Button Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4><i class="bi bi-file-text me-2"></i>Chi tiết Hóa đơn</h4>
                            <p class="text-muted mb-0">Thông tin chi tiết và phân tích chi phí hóa đơn</p>
                        </div>
                        <div>
                            <button onclick="window.print()" class="btn print-button">
                                <i class="bi bi-printer me-2"></i>In hóa đơn
                            </button>
                        </div>
                    </div>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Payment Reminder for Unpaid Invoices -->
                <c:if test="${invoice.status == 'UNPAID'}">
                    <div class="payment-reminder p-3 mb-4">
                        <div class="d-flex align-items-center">
                            <i class="bi bi-exclamation-triangle fs-3 text-warning me-3"></i>
                            <div>
                                <h6 class="mb-1 text-warning">Nhắc nhở thanh toán</h6>
                                <p class="mb-0">
                                    Hóa đơn này chưa được thanh toán. Vui lòng liên hệ quản trị viên để xác nhận thanh toán 
                                    hoặc thực hiện thanh toán theo thỏa thuận.
                                </p>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <!-- Invoice Detail -->
                <div class="row">
                    <div class="col-lg-8">
                        <!-- Invoice Header -->
                        <div class="card mb-4">
                            <div class="invoice-header p-4">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <h3 class="mb-1">HÓA ĐƠN #${invoice.invoiceId}</h3>
                                        <p class="mb-0 opacity-75">Kỳ thanh toán: ${invoice.formattedPeriod}</p>
                                    </div>
                                    <div class="col-md-6 text-end">
                                        <c:choose>
                                            <c:when test="${invoice.status == 'PAID'}">
                                                <span class="badge badge-paid fs-6 px-3 py-2">
                                                    <i class="bi bi-check-circle me-1"></i>Đã thanh toán
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-unpaid fs-6 px-3 py-2">
                                                    <i class="bi bi-exclamation-circle me-1"></i>Chưa thanh toán
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Invoice Info -->
                            <div class="card-body">
                                <div class="invoice-info p-3 mb-4">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6 class="text-primary mb-2"><i class="bi bi-people me-1"></i>Thông tin người thuê</h6>
                                            <c:choose>
                                                <c:when test="${fn:length(tenantsInRoom) > 1}">
                                                    <p class="mb-1"><strong>Số người thuê:</strong> ${fn:length(tenantsInRoom)} người</p>
                                                    <div class="mb-2">
                                                        <strong>Danh sách:</strong><br>
                                                        <c:forEach var="roomTenant" items="${tenantsInRoom}" varStatus="status">
                                                            <small class="text-muted">
                                                                <i class="bi bi-person me-1"></i>${roomTenant.fullName}
                                                                <c:if test="${not empty roomTenant.phone}"> - ${roomTenant.phone}</c:if>
                                                                <c:if test="${!status.last}"><br></c:if>
                                                            </small>
                                                        </c:forEach>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="mb-1"><strong>Họ tên:</strong> ${invoice.tenantName}</p>
                                                    <p class="mb-1"><strong>Số điện thoại:</strong> ${invoice.userPhone}</p>
                                                    <p class="mb-0"><strong>Email:</strong> ${invoice.userEmail}</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-primary mb-2"><i class="bi bi-door-open me-1"></i>Thông tin thanh toán</h6>
                                            <p class="mb-1"><strong>Phòng:</strong> ${invoice.roomName}</p>
                                            <p class="mb-1"><strong>Ngày tạo HĐ:</strong> 
                                                <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </p>
                                            <p class="mb-0"><strong>Mã hóa đơn:</strong> #${invoice.invoiceId}</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Cost Breakdown -->
                                <h6 class="mb-3"><i class="bi bi-pie-chart me-2"></i>Phân tích chi phí</h6>
                                <div class="row">
                                    <!-- Room Cost -->
                                    <div class="col-md-4 mb-3">
                                        <div class="cost-breakdown-card p-3">
                                            <div class="text-center">
                                                <i class="bi bi-house fs-1 text-primary mb-2"></i>
                                                <h6 class="mb-2">Tiền phòng</h6>
                                                <h4 class="text-primary mb-0">
                                                    <fmt:formatNumber value="${invoice.roomPrice}" type="number" maxFractionDigits="0"/> VNĐ
                                                </h4>
                                                <c:choose>
                                                    <c:when test="${isProrated}">
                                                        <small class="text-muted">Tính theo tỷ lệ ngày ở</small>
                                                        <br>
                                                        <small class="text-info">
                                                            <i class="bi bi-calendar-check me-1"></i>
                                                            ${daysStayed}/${daysInMonth} ngày
                                                            <c:if test="${earliestStartDate != null}">
                                                                <br>(từ <fmt:formatDate value="${earliestStartDate}" pattern="dd/MM/yyyy"/>)
                                                            </c:if>
                                                        </small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <small class="text-muted">Phí cơ bản hàng tháng</small>
                                                        <br>
                                                        <small class="text-info">
                                                            <i class="bi bi-calendar-check me-1"></i>
                                                            Cả tháng: ${daysInMonth} ngày
                                                        </small>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Service Cost -->
                                    <div class="col-md-4 mb-3">
                                        <div class="cost-breakdown-card p-3">
                                            <div class="text-center">
                                                <i class="bi bi-tools fs-1 text-info mb-2"></i>
                                                <h6 class="mb-2">Tiền dịch vụ</h6>
                                                <h4 class="text-info mb-0">
                                                    <fmt:formatNumber value="${invoice.serviceTotal}" type="number" maxFractionDigits="0"/> VNĐ
                                                </h4>
                                                <small class="text-muted">Điện, nước, internet...</small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Additional Cost -->
                                    <div class="col-md-4 mb-3">
                                        <div class="cost-breakdown-card p-3">
                                            <div class="text-center">
                                                <i class="bi bi-plus-circle fs-1 text-warning mb-2"></i>
                                                <h6 class="mb-2">Chi phí phát sinh</h6>
                                                <h4 class="text-warning mb-0">
                                                    <fmt:formatNumber value="${invoice.additionalTotal}" type="number" maxFractionDigits="0"/> VNĐ
                                                </h4>
                                                <small class="text-muted">Sửa chữa, vệ sinh...</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Service Usage Details -->
                        <c:if test="${not empty serviceUsages}">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="mb-0"><i class="bi bi-graph-up me-2"></i>Chi tiết Sử dụng Dịch vụ</h6>
                                    <c:if test="${fn:length(tenantsInRoom) > 1}">
                                        <small class="text-muted">
                                            <i class="bi bi-info-circle me-1"></i>
                                            Số liệu đã được tổng hợp cho tất cả ${fn:length(tenantsInRoom)} người thuê trong phòng
                                        </small>
                                    </c:if>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-sm mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Dịch vụ</th>
                                                    <th class="text-center">Số lượng</th>
                                                    <th class="text-center">Đơn giá</th>
                                                    <th class="text-end">Thành tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="serviceUsage" items="${serviceUsages}">
                                                    <tr>
                                                        <td>
                                                            <strong>${serviceUsage.serviceName}</strong><br>
                                                            <small class="text-muted">Đơn vị: ${serviceUsage.serviceUnit}</small>
                                                            <c:if test="${fn:length(tenantsInRoom) > 1}">
                                                                <br><small class="text-info">
                                                                    <i class="bi bi-people me-1"></i>Tổng hợp cho ${fn:length(tenantsInRoom)} người thuê
                                                                </small>
                                                            </c:if>
                                                        </td>
                                                        <td class="text-center">
                                                            <strong>${serviceUsage.quantity}</strong> ${serviceUsage.serviceUnit}
                                                            <c:if test="${fn:length(tenantsInRoom) > 1}">
                                                                <br><small class="text-muted">(Tổng cộng)</small>
                                                            </c:if>
                                                        </td>
                                                        <td class="text-center">
                                                            <fmt:formatNumber value="${serviceUsage.pricePerUnit}" type="number" maxFractionDigits="0"/> VNĐ
                                                        </td>
                                                        <td class="text-end">
                                                            <strong class="text-primary">
                                                                <fmt:formatNumber value="${serviceUsage.totalCost}" type="number" maxFractionDigits="0"/> VNĐ
                                                            </strong>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- Additional Costs Details -->
                        <c:if test="${not empty additionalCosts}">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="mb-0"><i class="bi bi-plus-circle me-2"></i>Chi tiết Chi phí Phát sinh</h6>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-sm mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Mô tả</th>
                                                    <th class="text-center">Ngày phát sinh</th>
                                                    <th class="text-end">Số tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="cost" items="${additionalCosts}">
                                                    <tr>
                                                        <td><strong>${cost.description}</strong></td>
                                                        <td class="text-center">
                                                            <fmt:formatDate value="${cost.date}" pattern="dd/MM/yyyy"/>
                                                        </td>
                                                        <td class="text-end">
                                                            <strong class="text-warning">
                                                                <fmt:formatNumber value="${cost.amount}" type="number" maxFractionDigits="0"/> VNĐ
                                                            </strong>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                    
                    <!-- Summary Sidebar -->
                    <div class="col-lg-4">
                        <!-- Total Amount -->
                        <div class="card total-amount mb-4">
                            <div class="card-body text-center">
                                <i class="bi bi-cash-stack fs-1 mb-3 opacity-75"></i>
                                <h5 class="mb-2">TỔNG CỘNG</h5>
                                <h1 class="mb-3">
                                    <fmt:formatNumber value="${invoice.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ
                                </h1>
                                <p class="mb-0 opacity-75">
                                    Kỳ thanh toán: ${invoice.formattedPeriod}<br>
                                    <c:if test="${isProrated}">
                                        <small class="text-warning">
                                            <i class="bi bi-info-circle me-1"></i>
                                            Tiền phòng tính theo ${daysStayed}/${daysInMonth} ngày
                                        </small><br>
                                    </c:if>
                                    <small>Đã bao gồm tất cả các khoản phí</small>
                                </p>
                            </div>
                        </div>
                        
                        <!-- MoMo QR Code -->
                        <c:if test="${invoice.hasMomoQrCode() && invoice.status == 'UNPAID'}">
                            <div class="card mb-4">
                                <div class="card-header bg-primary text-white">
                                    <h6 class="mb-0">
                                        <i class="bi bi-qr-code me-2"></i>Thanh toán MoMo
                                    </h6>
                                </div>
                                <div class="card-body text-center">
                                    <div class="mb-3">
                                        <img src="${invoice.momoQrCodeUrl}" alt="MoMo QR Code" 
                                             class="img-fluid" style="max-width: 200px; border: 2px solid #ddd; border-radius: 10px;">
                                    </div>
                                    <h6 class="text-primary mb-2">Quét mã QR để thanh toán</h6>
                                    <p class="text-muted small mb-3">
                                        Sử dụng ứng dụng MoMo để quét mã QR và thanh toán hóa đơn
                                    </p>
                                    <div class="d-grid gap-2">
                                        <a href="${invoice.momoQrCodeUrl}" target="_blank" class="btn btn-primary">
                                            <i class="bi bi-download me-2"></i>Tải mã QR
                                        </a>
                                        <form method="POST" action="${pageContext.request.contextPath}/payment/momo/regenerate-qr/${invoice.invoiceId}" style="display: inline;">
                                            <button type="submit" class="btn btn-outline-primary w-100">
                                                <i class="bi bi-arrow-clockwise me-2"></i>Tạo mã QR mới
                                            </button>
                                        </form>
                                    </div>
                                    <c:if test="${invoice.isMomoPending()}">
                                        <div class="alert alert-warning mt-3 mb-0">
                                            <small>
                                                <i class="bi bi-clock me-1"></i>
                                                Trạng thái: Đang chờ thanh toán
                                            </small>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- Actions -->
                        <div class="card">
                            <div class="card-header">
                                <h6 class="mb-0"><i class="bi bi-info-circle me-2"></i>Trạng thái & Hướng dẫn</h6>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label">Trạng thái hiện tại:</label>
                                    <div>
                                        <c:choose>
                                            <c:when test="${invoice.status == 'PAID'}">
                                                <span class="badge badge-paid fs-6 px-3 py-2">
                                                    <i class="bi bi-check-circle me-1"></i>Đã thanh toán
                                                </span>
                                                <p class="text-muted mt-2 mb-0">
                                                    <small><i class="bi bi-info-circle me-1"></i>
                                                    Hóa đơn này đã được thanh toán đầy đủ.</small>
                                                </p>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-unpaid fs-6 px-3 py-2">
                                                    <i class="bi bi-exclamation-circle me-1"></i>Chưa thanh toán
                                                </span>
                                                <div class="mt-3 p-3 bg-light rounded">
                                                    <h6 class="text-primary mb-2">
                                                        <i class="bi bi-cash me-1"></i>Hướng dẫn thanh toán:
                                                    </h6>
                                                    <ul class="small mb-0 ps-3">
                                                        <li>Liên hệ quản trị viên để xác nhận phương thức thanh toán</li>
                                                        <li>Thanh toán đúng số tiền: <strong><fmt:formatNumber value="${invoice.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ</strong>
                                                            <c:if test="${isProrated}">
                                                                <br><small class="text-info">(Tiền phòng đã tính theo ${daysStayed}/${daysInMonth} ngày)</small>
                                                            </c:if>
                                                        </li>
                                                        <li>Ghi rõ mã hóa đơn: <strong>#${invoice.invoiceId}</strong></li>
                                                        <li>Lưu giữ biên lai để đối chiếu</li>
                                                    </ul>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <hr>
                                
                                <!-- Actions -->
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/user/bills" class="btn btn-custom">
                                        <i class="bi bi-arrow-left me-2"></i>Về danh sách hóa đơn
                                    </a>
                                    
                                    <button onclick="window.print()" class="btn print-button">
                                        <i class="bi bi-printer me-2"></i>In hóa đơn này
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
