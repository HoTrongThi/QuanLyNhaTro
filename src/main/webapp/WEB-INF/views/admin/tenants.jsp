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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        
        .table th {
            background: #f8f9fa;
            border-top: none;
            font-weight: 600;
        }
        
        .badge-active {
            background: #28a745;
        }
        
        .badge-inactive {
            background: #6c757d;
        }
        
        .badge-warning {
            background: #ffc107;
            color: #212529;
        }
        
        .tenant-actions {
            white-space: nowrap;
        }
        
        .stats-cards .card {
            border-left: 4px solid;
            transition: transform 0.2s;
        }
        
        .stats-cards .card:hover {
            transform: translateY(-2px);
        }
        
        .stats-cards .card.border-primary {
            border-left-color: #667eea !important;
        }
        
        .stats-cards .card.border-success {
            border-left-color: #28a745 !important;
        }
        
        .stats-cards .card.border-secondary {
            border-left-color: #6c757d !important;
        }
        
        .search-form {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        /* Room Card Styles */
        .room-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        .room-card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            border-radius: 15px 15px 0 0;
        }
        
        .room-card-header.available {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        
        .room-card-header.occupied {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .room-name {
            font-size: 1.4em;
            font-weight: bold;
            margin: 0;
        }
        
        .room-status {
            font-size: 0.9em;
            opacity: 0.9;
            margin: 0;
        }
        
        .room-card-body {
            padding: 20px;
        }
        
        .tenants-list {
            margin-bottom: 15px;
        }
        
        .tenant-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 8px;
            border-left: 4px solid #667eea;
        }
        
        .tenant-name {
            font-weight: 600;
            color: #495057;
            margin-bottom: 2px;
        }
        
        .tenant-phone {
            font-size: 0.85em;
            color: #6c757d;
        }
        
        .services-section {
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 15px;
        }
        
        .services-title {
            font-size: 0.9em;
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }
        
        .service-badge {
            background: #e3f2fd;
            color: #1976d2;
            border: 1px solid #bbdefb;
            font-size: 0.75em;
            padding: 4px 8px;
            border-radius: 12px;
            margin: 2px;
            display: inline-block;
        }
        
        .room-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .room-actions .btn {
            flex: 1;
            min-width: 120px;
        }
        
        .empty-room {
            text-align: center;
            padding: 30px 20px;
            color: #6c757d;
        }
        
        .empty-room i {
            font-size: 2.5em;
            margin-bottom: 10px;
            opacity: 0.5;
        }
        
        .room-price {
            font-size: 1.1em;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 15px;
        }
        
        /* Filter styles */
        #roomStatusFilter {
            border: 1px solid #dee2e6;
            transition: all 0.3s ease;
        }
        
        #roomStatusFilter:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .filter-info {
            border-left: 4px solid #0dcaf0;
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .room-card {
            transition: all 0.3s ease;
        }
        
        .room-card.filtered-out {
            display: none;
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
                        <i class="bi bi-building me-2"></i>
                        Admin Panel
                    </h4>
                    
                    <div class="text-center mb-4">
                        <div class="bg-light text-dark rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 60px; height: 60px;">
                            <i class="bi bi-person-gear fs-3"></i>
                        </div>
                        <div class="mt-2">
                            <strong>${user.fullName}</strong>
                            <br>
                            <small class="text-light">Quản trị viên</small>
                        </div>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-speedometer2 me-2"></i>
                            Bảng điều khiển
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people me-2"></i>
                            Quản lý Người dùng
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/rooms">
                            <i class="bi bi-door-open me-2"></i>
                            Quản lý Phòng trọ
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/services">
                            <i class="bi bi-tools me-2"></i>
                            Quản lý Dịch vụ
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/tenants">
                            <i class="bi bi-person-check me-2"></i>
                            Quản lý Thuê trọ
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/additional-costs">
                            <i class="bi bi-receipt-cutoff me-2"></i>
                            Chi phí phát sinh
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/bills">
                            <i class="bi bi-receipt me-2"></i>
                            Quản lý Hóa đơn
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                            <i class="bi bi-graph-up me-2"></i>
                            Báo cáo & Thống kê
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
                                    <li><a class="dropdown-item" href="#">Thông tin cá nhân</a></li>
                                    <li><a class="dropdown-item" href="#">Cài đặt</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>
                
                <!-- Tenant Management Content -->
                <div class="p-4">
                    <!-- Statistics Cards -->
                    <div class="stats-cards row mb-4">
                        <div class="col-md-4 mb-3">
                            <div class="card border-primary">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-1">Tổng số thuê trọ</h6>
                                            <h3 class="mb-0 text-primary">${totalTenants}</h3>
                                        </div>
                                        <div class="text-primary">
                                            <i class="bi bi-people fs-1"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card border-success">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-1">Đang thuê</h6>
                                            <h3 class="mb-0 text-success">${activeTenants}</h3>
                                        </div>
                                        <div class="text-success">
                                            <i class="bi bi-person-check fs-1"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card border-secondary">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-1">Đã kết thúc</h6>
                                            <h3 class="mb-0 text-secondary">${inactiveTenants}</h3>
                                        </div>
                                        <div class="text-secondary">
                                            <i class="bi bi-person-x fs-1"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Search and Actions -->
                    <div class="search-form mb-4">
                        <div class="row align-items-end">
                            <div class="col-md-6">
                                <form method="GET" action="${pageContext.request.contextPath}/admin/tenants">
                                    <div class="input-group">
                                        <input type="text" 
                                               class="form-control" 
                                               name="search" 
                                               placeholder="Tìm kiếm theo tên phòng hoặc tên khách thuê..." 
                                               value="${searchTerm}">
                                        <button class="btn btn-outline-secondary" type="submit">
                                            <i class="bi bi-search"></i>
                                        </button>
                                        <c:if test="${not empty searchTerm}">
                                            <a href="${pageContext.request.contextPath}/admin/tenants" 
                                               class="btn btn-outline-warning">
                                                <i class="bi bi-x-circle"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </form>
                                <c:if test="${not empty searchTerm}">
                                    <small class="text-muted mt-1 d-block">
                                        Tìm thấy kết quả cho "${searchTerm}"
                                    </small>
                                </c:if>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex justify-content-end align-items-center gap-2">
                                    <!-- Bộ lọc trạng thái phòng -->
                                    <div class="d-flex align-items-center">
                                        <label for="roomStatusFilter" class="form-label me-2 mb-0 text-muted">
                                            <i class="bi bi-funnel me-1"></i>
                                            Lọc:
                                        </label>
                                        <select class="form-select form-select-sm" id="roomStatusFilter" style="min-width: 140px;">
                                            <option value="">Tất cả phòng</option>
                                            <option value="AVAILABLE">🚪 Phòng trống</option>
                                            <option value="OCCUPIED">👤 Đã thuê</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Nút thêm thuê trọ -->
                                    <a href="${pageContext.request.contextPath}/admin/tenants/add" 
                                       class="btn btn-primary">
                                        <i class="bi bi-plus-circle me-1"></i>
                                        Thêm Thuê trọ mới
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    
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
                    
                    <!-- Room Cards Grid -->
                    <div class="mb-3">
                        <h5 class="text-muted">
                            <i class="bi bi-grid-3x3-gap me-2"></i>
                            Danh sách Phòng trọ
                        </h5>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty rooms}">
                            <div class="row">
                                <c:forEach var="room" items="${rooms}" varStatus="status">
                                    <div class="col-lg-4 col-md-6 mb-4">
                                        <div class="room-card">
                                            <!-- Room Header -->
                                            <div class="room-card-header ${room.status == 'AVAILABLE' ? 'available' : 'occupied'}">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <h5 class="room-name">
                                                            <i class="bi bi-door-open me-2"></i>
                                                            ${room.roomName}
                                                        </h5>
                                                        <p class="room-status">
                                                            <c:choose>
                                                                <c:when test="${room.status == 'AVAILABLE'}">
                                                                    <i class="bi bi-check-circle me-1"></i>
                                                                    Phòng trống
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="bi bi-people me-1"></i>
                                                                    Đang có người thuê
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </p>
                                                    </div>
                                                    <div class="text-end">
                                                        <c:set var="tenantCount" value="${roomTenantCounts[room.roomId]}" />
                                                        <span class="badge bg-light text-dark">
                                                            ${tenantCount != null ? tenantCount : 0}/4
                                                        </span>
                                                        <br>
                                                        <c:choose>
                                                            <c:when test="${room.paymentStatus != null and fn:startsWith(room.paymentStatus, 'UNPAID')}">
                                                                <span class="badge bg-danger mt-1">
                                                                    <i class="bi bi-exclamation-triangle me-1"></i>
                                                                    Đang nợ
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${tenantCount != null and tenantCount > 0}">
                                                                <span class="badge bg-success mt-1">
                                                                    <i class="bi bi-check-circle me-1"></i>
                                                                    Đã thanh toán
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary mt-1">
                                                                    <i class="bi bi-dash-circle me-1"></i>
                                                                    Chưa có người thuê
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Room Body -->
                                            <div class="room-card-body">
                                                <!-- Room Price -->
                                                <div class="room-price">
                                                    <i class="bi bi-currency-dollar me-1"></i>
                                                    <fmt:formatNumber value="${room.price}" 
                                                                    type="currency" 
                                                                    currencySymbol="₫" 
                                                                    groupingUsed="true"/>/tháng
                                                </div>
                                                
                                                <!-- Tenants List -->
                                                <c:choose>
                                                    <c:when test="${not empty roomTenantsMap[room.roomId]}">
                                                        <div class="tenants-list">
                                                            <h6 class="text-muted mb-2">
                                                                <i class="bi bi-people me-1"></i>
                                                                Khách thuê hiện tại:
                                                            </h6>
                                                            <c:forEach var="tenant" items="${roomTenantsMap[room.roomId]}">
                                                                <div class="tenant-item">
                                                                    <div class="tenant-name">${tenant.fullName}</div>
                                                                    <div class="tenant-phone">
                                                                        <i class="bi bi-telephone me-1"></i>
                                                                        ${not empty tenant.phone ? tenant.phone : 'Chưa có SĐT'}
                                                                    </div>
                                                                    <div class="tenant-phone">
                                                                        <i class="bi bi-calendar me-1"></i>
                                                                        Từ: <fmt:formatDate value="${tenant.startDate}" pattern="dd/MM/yyyy"/>
                                                                    </div>
                                                                    <div class="tenant-phone">
                                                                        <span class="badge ${tenant.statusBadgeClass}">
                                                                            ${tenant.detailedStatus}
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="empty-room">
                                                            <i class="bi bi-house"></i>
                                                            <p class="mb-0">Phòng trống</p>
                                                            <small>Sẵn sàng cho thuê</small>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <!-- Services List -->
                                                <div class="services-section">
                                                    <div class="services-title">
                                                        <i class="bi bi-tools me-1"></i>
                                                        Dịch vụ có sẵn:
                                                    </div>
                                                    <c:choose>
                                                        <c:when test="${not empty roomServicesMap[room.roomId]}">
                                                            <c:forEach var="service" items="${roomServicesMap[room.roomId]}">
                                                                <span class="service-badge">${service}</span>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <small class="text-muted">
                                                                <i class="bi bi-dash-circle me-1"></i>
                                                                Chưa có dịch vụ
                                                            </small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <!-- Room Actions -->
                                                <div class="room-actions">
                                                    <c:choose>
                                                        <c:when test="${room.status == 'AVAILABLE'}">
                                                            <a href="${pageContext.request.contextPath}/admin/tenants/add?roomId=${room.roomId}" 
                                                               class="btn btn-success btn-sm">
                                                                <i class="bi bi-plus-circle me-1"></i>
                                                                Thêm khách thuê
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/admin/rooms/edit/${room.roomId}" 
                                                               class="btn btn-outline-primary btn-sm">
                                                                <i class="bi bi-gear me-1"></i>
                                                                Cài đặt phòng
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:if test="${not empty roomTenantsMap[room.roomId]}">
                                                                <c:set var="firstTenant" value="${roomTenantsMap[room.roomId][0]}" />
                                                                <a href="${pageContext.request.contextPath}/admin/tenants/view/${firstTenant.tenantId}" 
                                                                   class="btn btn-info btn-sm">
                                                                    <i class="bi bi-eye me-1"></i>
                                                                    Xem chi tiết
                                                                </a>
                                                                <button type="button" 
                                                                        class="btn btn-outline-danger btn-sm" 
                                                                        onclick="confirmEndLease(${firstTenant.tenantId}, '${firstTenant.fullName}')">
                                                                    <i class="bi bi-stop-circle me-1"></i>
                                                                    Kết thúc thuê
                                                                </button>
                                                            </c:if>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="bi bi-house text-muted" style="font-size: 3rem;"></i>
                                <h5 class="text-muted mt-3">
                                    <c:choose>
                                        <c:when test="${not empty searchTerm}">
                                            Không tìm thấy phòng nào với từ khóa "${searchTerm}"
                                        </c:when>
                                        <c:otherwise>
                                            Chưa có phòng nào trong hệ thống
                                        </c:otherwise>
                                    </c:choose>
                                </h5>
                                <p class="text-muted">
                                    <c:choose>
                                        <c:when test="${not empty searchTerm}">
                                            Thử tìm kiếm với từ khóa khác hoặc 
                                            <a href="${pageContext.request.contextPath}/admin/tenants">xem tất cả phòng</a>
                                        </c:when>
                                        <c:otherwise>
                                            Hãy thêm phòng trước khi quản lý thuê trọ
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <c:if test="${empty searchTerm}">
                                    <a href="${pageContext.request.contextPath}/admin/rooms/add" 
                                       class="btn btn-primary">
                                        <i class="bi bi-plus-circle me-1"></i>
                                        Thêm Phòng mới
                                    </a>
                                </c:if>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <!-- End Lease Confirmation Modal -->
    <div class="modal fade" id="endLeaseModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận kết thúc hợp đồng thuê</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn kết thúc hợp đồng thuê của <strong id="tenantNameToEnd"></strong>?</p>
                    <div class="mb-3">
                        <label for="endDate" class="form-label">Ngày kết thúc (để trống = hôm nay)</label>
                        <input type="date" class="form-control" id="endDate" name="endDate">
                        <div class="form-text">
                            <i class="bi bi-info-circle me-1"></i>
                            <strong>Lưu ý:</strong> Nếu chọn ngày trong tương lai, hợp đồng sẽ tự động kết thúc vào ngày đó.
                        </div>
                    </div>
                    <div class="alert alert-info">
                        <i class="bi bi-calendar-check me-1"></i>
                        <strong>Tính năng mới:</strong> Bạn có thể lên lịch kết thúc hợp đồng trong tương lai. 
                        Hệ thống sẽ tự động xử lý khi đến ngày đó.
                    </div>
                    <p class="text-warning">
                        <i class="bi bi-exclamation-triangle me-1"></i>
                        Phòng sẽ được cập nhật trạng thái tự động khi hợp đồng kết thúc!
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form id="endLeaseForm" method="POST" style="display: inline;">
                        <input type="hidden" id="endDateInput" name="endDate">
                        <button type="submit" class="btn btn-danger">Kết thúc hợp đồng</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        
        function confirmEndLease(tenantId, tenantName) {
            document.getElementById('tenantNameToEnd').textContent = tenantName;
            document.getElementById('endLeaseForm').action = '${pageContext.request.contextPath}/admin/tenants/end/' + tenantId;
            
            var endLeaseModal = new bootstrap.Modal(document.getElementById('endLeaseModal'));
            endLeaseModal.show();
            
            // Set today as default end date
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('endDate').value = today;
        }
        
        // Update hidden input when date changes
        document.getElementById('endDate').addEventListener('change', function() {
            document.getElementById('endDateInput').value = this.value;
        });
        
        // Set default value on form submit
        document.getElementById('endLeaseForm').addEventListener('submit', function() {
            const endDate = document.getElementById('endDate').value;
            document.getElementById('endDateInput').value = endDate;
        });
        
        // Room status filter functionality
        document.addEventListener('DOMContentLoaded', function() {
            var roomStatusFilter = document.getElementById('roomStatusFilter');
            if (roomStatusFilter) {
                roomStatusFilter.addEventListener('change', function() {
                    filterRoomsByStatus(this.value);
                });
                
                // Check for filter parameter in URL
                var urlParams = new URLSearchParams(window.location.search);
                var filterParam = urlParams.get('filter');
                if (filterParam) {
                    roomStatusFilter.value = filterParam;
                    filterRoomsByStatus(filterParam);
                    
                    // Show notification that filter was applied from dashboard
                    showDashboardFilterNotification(filterParam);
                }
            }
        });
        
        // Function to filter rooms by status
        function filterRoomsByStatus(selectedStatus) {
            var roomCards = document.querySelectorAll('.room-card');
            var visibleCount = 0;
            
            roomCards.forEach(function(card) {
                var roomHeader = card.querySelector('.room-card-header');
                if (!roomHeader) return;
                
                // Determine room status from header class
                var roomStatus = '';
                if (roomHeader.classList.contains('available')) {
                    roomStatus = 'AVAILABLE';
                } else if (roomHeader.classList.contains('occupied')) {
                    roomStatus = 'OCCUPIED';
                }
                
                // Show/hide room card based on filter
                if (selectedStatus === '' || roomStatus === selectedStatus) {
                    card.style.display = '';
                    card.classList.remove('filtered-out');
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                    card.classList.add('filtered-out');
                }
            });
            
            // Update filter result info
            updateFilterInfo(selectedStatus, visibleCount, roomCards.length);
        }
        
        // Function to update filter information
        function updateFilterInfo(selectedStatus, visibleCount, totalCount) {
            // Remove existing filter info
            var existingInfo = document.querySelector('.filter-info');
            if (existingInfo) {
                existingInfo.remove();
            }
            
            // Add new filter info if filtering is active
            if (selectedStatus !== '') {
                var roomsContainer = document.querySelector('.row');
                if (roomsContainer && roomsContainer.querySelector('.room-card')) {
                    var filterInfo = document.createElement('div');
                    filterInfo.className = 'filter-info alert alert-info mb-3';
                    
                    var statusNames = {
                        'AVAILABLE': 'Phòng trống',
                        'OCCUPIED': 'Đã thuê'
                    };
                    
                    filterInfo.innerHTML = '<i class="bi bi-info-circle me-2"></i>' +
                        'Hiển thị <strong>' + visibleCount + '</strong> phòng có trạng thái "<strong>' + 
                        statusNames[selectedStatus] + '</strong>" trên tổng số <strong>' + totalCount + '</strong> phòng. ' +
                        '<a href="#" onclick="clearRoomFilter()" class="alert-link">Xóa bộ lọc</a>';
                    
                    // Insert before room cards
                    var roomsTitle = document.querySelector('.mb-3 h5');
                    if (roomsTitle && roomsTitle.parentNode) {
                        roomsTitle.parentNode.insertBefore(filterInfo, roomsTitle.nextSibling);
                    }
                }
            }
        }
        
        // Function to clear filter
        function clearRoomFilter() {
            var roomStatusFilter = document.getElementById('roomStatusFilter');
            if (roomStatusFilter) {
                roomStatusFilter.value = '';
                filterRoomsByStatus('');
            }
        }
        
        // Function to show dashboard filter notification
        function showDashboardFilterNotification(filterValue) {
            var statusNames = {
                'AVAILABLE': 'Phòng trống',
                'OCCUPIED': 'Đã thuê'
            };
            
            // Create notification element
            var notification = document.createElement('div');
            notification.className = 'alert alert-success alert-dismissible fade show dashboard-notification';
            notification.innerHTML = '<i class="bi bi-speedometer2 me-2"></i>' +
                '<strong>Từ Bảng điều khiển:</strong> Đã lọc hiển thị phòng có trạng thái "<strong>' + 
                statusNames[filterValue] + '</strong>". ' +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            
            // Insert notification after success/error messages
            var mainContent = document.querySelector('.p-4');
            var statsCards = mainContent.querySelector('.stats-cards');
            if (statsCards) {
                mainContent.insertBefore(notification, statsCards);
            }
            
            // Auto-hide after 5 seconds
            setTimeout(function() {
                if (notification && notification.parentNode) {
                    notification.classList.remove('show');
                    setTimeout(function() {
                        if (notification && notification.parentNode) {
                            notification.remove();
                        }
                    }, 150);
                }
            }, 5000);
        }
    </script>
</body>
</html>
