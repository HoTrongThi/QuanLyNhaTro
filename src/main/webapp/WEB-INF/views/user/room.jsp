<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin Phòng - Quản lý Phòng trọ</title>
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
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px;
        }
        
        .service-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            border-left: 4px solid #28a745;
        }
        
        .no-room-card {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
            border-radius: 15px;
            text-align: center;
            padding: 3rem;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/user/room">
                            <i class="bi bi-house-door me-2"></i>
                            Thông tin Phòng
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/bills">
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
                        <h5 class="navbar-brand mb-0">Thông tin Phòng</h5>
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

                <!-- Room Content Here -->
                <div class="container py-4">
                    <c:choose>
                        <c:when test="${currentTenant != null}">
                            <!-- Room Information -->
                            <div class="row">
                                <!-- Room Details -->
                                <div class="col-lg-8">
                                    <div class="card room-info-card mb-4">
                                        <div class="card-body p-4">
                                            <div class="row align-items-center">
                                                <div class="col-md-8">
                                                    <h3 class="mb-1">
                                                        <i class="bi bi-door-open me-2"></i>
                                                        ${currentTenant.roomName}
                                                    </h3>
                                                    <p class="mb-3 text-muted">Thông tin chi tiết về phòng trọ của bạn</p>
                                                    
                                                    <div class="row text-start">
                                                        <div class="col-md-6 mb-2">
                                                            <i class="bi bi-calendar-date me-1 text-primary"></i>
                                                            <strong>Ngày bắt đầu:</strong><br>
                                                            <small class="text-muted"><fmt:formatDate value="${currentTenant.startDate}" pattern="dd/MM/yyyy"/></small>
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <i class="bi bi-geo-alt me-1 text-primary"></i>
                                                            <strong>Trạng thái:</strong><br>
                                                            <small><span class="badge bg-success">Đang thuê</span></small>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-4 text-center">
                                                    <div class="display-4 fw-bold text-success">
                                                        <fmt:formatNumber value="${currentTenant.roomPrice}" type="currency" currencySymbol="" pattern="#,##0"/>₫
                                                    </div>
                                                    <small class="text-muted">Tiền phòng/tháng</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Room Details Card -->
                                    <c:if test="${roomDetails != null}">
                                        <div class="card mb-4">
                                            <div class="card-header">
                                                <h5 class="mb-0">
                                                    <i class="bi bi-info-circle me-2"></i>
                                                    Chi tiết Phòng
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="mb-3">
                                                            <label class="form-label text-muted">Tên phòng:</label>
                                                            <div class="fw-bold fs-5">${roomDetails.roomName}</div>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label text-muted">Giá thuê:</label>
                                                            <div class="fw-bold text-success fs-5">
                                                                <fmt:formatNumber value="${roomDetails.price}" type="currency" currencySymbol="" pattern="#,##0"/>₫/tháng
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="mb-3">
                                                            <label class="form-label text-muted">Trạng thái:</label>
                                                            <div>
                                                                <c:choose>
                                                                    <c:when test="${roomDetails.status == 'AVAILABLE'}">
                                                                        <span class="badge bg-success fs-6">Có sẵn</span>
                                                                    </c:when>
                                                                    <c:when test="${roomDetails.status == 'OCCUPIED'}">
                                                                        <span class="badge bg-warning fs-6">Đang thuê</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary fs-6">Bảo trì</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label text-muted">Mô tả:</label>
                                                            <div class="text-muted">${not empty roomDetails.description ? roomDetails.description : 'Không có mô tả'}</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Services Used -->
                                    <div class="card mb-4">
                                        <div class="card-header">
                                            <h5 class="mb-0">
                                                <i class="bi bi-tools me-2"></i>
                                                Dịch vụ đang sử dụng
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <c:choose>
                                                <c:when test="${not empty roomServices}">
                                                    <div class="row">
                                                        <c:forEach var="service" items="${roomServices}">
                                                            <div class="col-md-6 mb-3">
                                                                <div class="service-item">
                                                                    <div class="d-flex align-items-center">
                                                                        <i class="bi bi-gear-fill text-primary me-3 fs-4"></i>
                                                                        <div>
                                                                            <h6 class="mb-1">${service.serviceName}</h6>
                                                                            <span class="text-success fw-bold">
                                                                                <fmt:formatNumber value="${service.pricePerUnit}" type="number" maxFractionDigits="0"/>₫/${service.unit}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="text-center py-4">
                                                        <i class="bi bi-tools text-muted" style="font-size: 3rem;"></i>
                                                        <h6 class="text-muted mt-2">Chưa có dịch vụ nào được sử dụng</h6>
                                                        <p class="text-muted">Liên hệ với quản lý để đăng ký dịch vụ</p>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Right Sidebar -->
                                <div class="col-lg-4">
                                    <!-- Monthly Cost Summary -->
                                    <div class="card cost-summary mb-4">
                                        <div class="card-body text-center p-4">
                                            <i class="bi bi-calculator fs-1 mb-3 text-white"></i>
                                            <h5 class="mb-3 text-white">Tổng chi phí hàng tháng</h5>
                                            
                                            <div class="mb-3 text-white">
                                                <div class="d-flex justify-content-between mb-2">
                                                    <span>Tiền phòng:</span>
                                                    <strong><fmt:formatNumber value="${currentTenant.roomPrice}" type="currency" currencySymbol="" pattern="#,##0"/>₫</strong>
                                                </div>
                                                <div class="d-flex justify-content-between mb-2">
                                                    <span>Tiền dịch vụ:</span>
                                                    <strong><fmt:formatNumber value="${monthlyServiceCost}" type="currency" currencySymbol="" pattern="#,##0"/>₫</strong>
                                                </div>
                                                <hr class="my-2" style="border-color: rgba(255,255,255,0.3);">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="fw-bold">Tổng cộng:</span>
                                                    <h4 class="fw-bold mb-0"><fmt:formatNumber value="${totalMonthlyCost}" type="currency" currencySymbol="" pattern="#,##0"/>₫</h4>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Recent Invoices -->
                                    <div class="card mb-4">
                                        <div class="card-header">
                                            <h6 class="mb-0">
                                                <i class="bi bi-receipt me-2"></i>
                                                Hóa đơn gần đây
                                            </h6>
                                        </div>
                                        <div class="card-body">
                                            <c:choose>
                                                <c:when test="${not empty recentInvoices}">
                                                    <c:forEach var="invoice" items="${recentInvoices}" varStatus="status" end="2">
                                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                                            <div>
                                                                <div class="fw-bold">Hóa đơn #${invoice.invoiceId}</div>
                                                                <small class="text-muted">
                                                                    <i class="bi bi-calendar me-1"></i>
                                                                    <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy"/>
                                                                </small>
                                                            </div>
                                                            <div class="text-end">
                                                                <div class="fw-bold text-primary">
                                                                    <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="" pattern="#,##0"/>₫
                                                                </div>
                                                                <c:choose>
                                                                    <c:when test="${invoice.status == 'PAID'}">
                                                                        <small class="badge bg-success">Đã thanh toán</small>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <small class="badge bg-warning">Chưa thanh toán</small>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                        <c:if test="${!status.last && status.index < 2}"><hr></c:if>
                                                    </c:forEach>
                                                    <div class="text-center mt-3">
                                                        <a href="${pageContext.request.contextPath}/user/bills" class="btn btn-outline-primary btn-sm">
                                                            Xem tất cả hóa đơn
                                                        </a>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="text-center py-3">
                                                        <i class="bi bi-receipt text-muted" style="font-size: 2rem;"></i>
                                                        <p class="text-muted mt-2 mb-0">Chưa có hóa đơn nào</p>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <!-- Quick Actions -->
                                    <div class="card">
                                        <div class="card-header">
                                            <h6 class="mb-0">
                                                <i class="bi bi-lightning-charge me-2"></i>
                                                Thao tác nhanh
                                            </h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="d-grid gap-2">
                                                <a href="${pageContext.request.contextPath}/user/bills" class="btn btn-outline-primary">
                                                    <i class="bi bi-receipt me-2"></i>Xem hóa đơn
                                                </a>
                                                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline-secondary">
                                                    <i class="bi bi-person me-2"></i>Cập nhật thông tin
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- No Room Message -->
                            <div class="no-room-card">
                                <i class="bi bi-house-door text-white" style="font-size: 4rem;"></i>
                                <h3 class="text-white mt-3">Bạn chưa thuê phòng nào</h3>
                                <p class="text-white-50">
                                    Hiện tại bạn chưa thuê phòng trọ nào trong hệ thống.<br>
                                    Vui lòng liên hệ với quản lý để được hỗ trợ thuê phòng.
                                </p>
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/user/dashboard" class="btn btn-light me-2">
                                        <i class="bi bi-arrow-left me-1"></i>
                                        Quay lại Dashboard
                                    </a>
                                    <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline-light">
                                        <i class="bi bi-person me-1"></i>
                                        Xem thông tin cá nhân
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
