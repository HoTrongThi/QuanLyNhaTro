<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/user/dashboard">
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
                
                <!-- Dashboard Content -->
                <div class="p-4">
                    <!-- Welcome Card -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h4>Xin chào, ${user.fullName}!</h4>
                                    <p class="text-muted mb-0">Chào mừng bạn đến với hệ thống quản lý phòng trọ</p>
                                </div>
                                <div class="col-auto">
                                    <i class="bi bi-house-heart fs-1 text-success"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Tenant Status Card -->
                    <c:choose>
                        <c:when test="${currentTenant != null}">
                            <div class="row mb-4">
                                <div class="col-12 mb-3">
                                    <div class="card border-success">
                                        <div class="card-header bg-success text-white">
                                            <h5 class="mb-0">
                                                <i class="bi bi-house-check me-2"></i>
                                                Thông tin phòng hiện tại
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-3 mb-3">
                                                    <strong>Phòng:</strong>
                                                    <div class="text-success fs-4">${currentTenant.roomName}</div>
                                                </div>
                                                <div class="col-md-3 mb-3">
                                                    <strong>Giá phòng:</strong>
                                                    <div class="text-primary">${currentTenant.roomPrice} VNĐ/tháng</div>
                                                </div>
                                                <div class="col-md-3 mb-3">
                                                    <strong>Ngày bắt đầu:</strong>
                                                    <div>${currentTenant.startDate}</div>
                                                </div>
                                                <div class="col-md-3 mb-3">
                                                    <strong>Trạng thái:</strong>
                                                    <div class="text-success">
                                                        <i class="bi bi-check-circle me-1"></i>
                                                        Đang thuê
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Quick Info Cards for Tenant -->
                            <div class="row mb-4">
                                <div class="col-md-6 mb-3">
                                    <div class="card bg-info text-white">
                                        <div class="card-body text-center">
                                            <i class="bi bi-calendar-month fs-1 mb-2"></i>
                                            <h3>Tháng này</h3>
                                            <p class="mb-0">Hóa đơn tháng này</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="card bg-warning text-white">
                                        <div class="card-body text-center">
                                            <i class="bi bi-receipt fs-1 mb-2"></i>
                                            <h3>0</h3>
                                            <p class="mb-0">Hóa đơn chờ thanh toán</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Quick Info Cards for Non-Tenant -->
                            <div class="row mb-4">
                                <div class="col-12 mb-3">
                                    <div class="card border-warning">
                                        <div class="card-body text-center">
                                            <i class="bi bi-house-door fs-1 mb-3 text-warning"></i>
                                            <h4 class="text-warning">Chưa thuê phòng</h4>
                                            <p class="text-muted">Bạn chưa được phân phòng. Vui lòng liên hệ quản lý để được hỗ trợ.</p>
                                            <div class="mt-3">
                                                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-warning">
                                                    <i class="bi bi-person-gear me-1"></i>
                                                    Cập nhật thông tin cá nhân
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- User Info Card -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-person-badge me-2"></i>
                                Thông tin tài khoản
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <strong>Tên đăng nhập:</strong> ${user.username}
                                    </div>
                                    <div class="mb-3">
                                        <strong>Họ và tên:</strong> ${user.fullName}
                                    </div>
                                    <div class="mb-3">
                                        <strong>Email:</strong> ${user.email}
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <strong>Số điện thoại:</strong> 
                                        <c:choose>
                                            <c:when test="${not empty user.phone}">${user.phone}</c:when>
                                            <c:otherwise><span class="text-muted">Chưa cập nhật</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mb-3">
                                        <strong>Địa chỉ:</strong> 
                                        <c:choose>
                                            <c:when test="${not empty user.address}">${user.address}</c:when>
                                            <c:otherwise><span class="text-muted">Chưa cập nhật</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mb-3">
                                        <strong>Ngày tạo tài khoản:</strong> ${user.createdAt}
                                    </div>
                                </div>
                            </div>
                            <div class="text-end">
                                <a href="${pageContext.request.contextPath}/user/profile" 
                                   class="btn btn-outline-primary">
                                    <i class="bi bi-pencil me-1"></i>
                                    Chỉnh sửa thông tin
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Quick Actions -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-lightning-charge me-2"></i>
                                Thao tác nhanh
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <a href="${pageContext.request.contextPath}/user/room" 
                                       class="btn btn-outline-success btn-lg w-100">
                                        <i class="bi bi-house-door fs-4 d-block mb-2"></i>
                                        Xem thông tin phòng
                                    </a>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <a href="${pageContext.request.contextPath}/user/bills" 
                                       class="btn btn-outline-warning btn-lg w-100">
                                        <i class="bi bi-receipt fs-4 d-block mb-2"></i>
                                        Xem hóa đơn
                                    </a>
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
