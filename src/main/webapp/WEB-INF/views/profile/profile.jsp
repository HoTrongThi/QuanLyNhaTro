<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân - Quản lý Phòng trọ</title>
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
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-icon {
            background: linear-gradient(135deg, rgba(40, 167, 69, 0.1) 0%, rgba(32, 201, 151, 0.1) 100%);
            color: #28a745;
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            flex-shrink: 0;
        }
        
        .info-content {
            flex: 1;
        }
        
        .info-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            color: #666;
        }
        
        .current-rental {
            background: linear-gradient(135deg, rgba(40, 167, 69, 0.1) 0%, rgba(32, 201, 151, 0.1) 100%);
            border: 2px solid #28a745;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .rental-icon {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/user/profile">
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
                        <h5 class="navbar-brand mb-0">Thông tin cá nhân</h5>
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

                <!-- Profile Content -->
                <div class="container py-4">
                    <!-- Success/Error Messages -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>
                            ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
        
                    <!-- Welcome Card -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h4>Xin chào, ${user.fullName}!</h4>
                                    <p class="text-muted mb-0">Chào mừng bạn đến với hệ thống quản lý phòng trọ</p>
                                </div>
                                <div class="col-auto">
                                    <div class="d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/user/profile/edit" class="btn btn-success">
                                            <i class="bi bi-pencil me-2"></i>Chỉnh sửa thông tin
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
        
                    <div class="row">
                        <!-- Personal Information -->
                        <div class="col-lg-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-person-card me-2"></i>
                                        Thông tin cá nhân
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="bi bi-person"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Họ và tên</div>
                                            <div class="info-value fw-bold">${user.fullName}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="bi bi-envelope"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Email</div>
                                            <div class="info-value">${user.email}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="bi bi-telephone"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Số điện thoại</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty user.phone}">
                                                        ${user.phone}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Chưa cập nhật</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="bi bi-geo-alt"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Địa chỉ</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty user.address}">
                                                        ${user.address}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Chưa cập nhật</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="bi bi-calendar-plus"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Ngày tham gia</div>
                                            <div class="info-value">
                                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Rental Information -->
                        <div class="col-lg-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-house me-2"></i>
                                        Thông tin thuê trọ
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${currentTenant != null}">
                                            <div class="current-rental">
                                                <div class="d-flex align-items-center mb-3">
                                                    <div class="rental-icon me-3">
                                                        <i class="bi bi-house-door"></i>
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-0">Đang thuê: ${currentTenant.roomName}</h6>
                                                        <small class="text-success">Hợp đồng đang có hiệu lực</small>
                                                    </div>
                                                </div>
                                                
                                                <div class="row">
                                                    <div class="col-6">
                                                        <div class="info-label">Giá phòng/tháng</div>
                                                        <div class="info-value text-success fw-bold">
                                                            <fmt:formatNumber value="${currentTenant.roomPrice}" 
                                                                            type="currency" 
                                                                            currencySymbol="₫" 
                                                                            groupingUsed="true"/>
                                                        </div>
                                                    </div>
                                                    <div class="col-6">
                                                        <div class="info-label">Ngày bắt đầu</div>
                                                        <div class="info-value">
                                                            <fmt:formatDate value="${currentTenant.startDate}" pattern="dd/MM/yyyy"/>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="text-center">
                                                <p class="text-muted">Bạn đang thuê phòng tại hệ thống của chúng tôi.</p>
                                                <a href="${pageContext.request.contextPath}/user/room" class="btn btn-outline-success me-2">
                                                    <i class="bi bi-house-door me-2"></i>
                                                    Xem thông tin phòng
                                                </a>
                                                <a href="${pageContext.request.contextPath}/user/bills" class="btn btn-outline-info">
                                                    <i class="bi bi-receipt me-2"></i>
                                                    Xem hóa đơn
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-4">
                                                <i class="bi bi-house-x text-muted" style="font-size: 3rem;"></i>
                                                <h6 class="text-muted mt-3">Hiện tại bạn chưa thuê phòng nào</h6>
                                                <p class="text-muted">Liên hệ với quản lý để được hỗ trợ thuê phòng phù hợp.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
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
